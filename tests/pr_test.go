// Tests in this file are run in the PR pipeline
package test

import (
	"fmt"
	"log"
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/common"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testschematic"
)

const resourceGroup = "geretain-test-resources"
const defaultExampleTerraformDir = "examples/default"
const fullyConfigurableDir = "solutions/fully-configurable"

// Define a struct with fields that match the structure of the YAML data
const yamlLocation = "../common-dev-assets/common-go-assets/common-permanent-resources.yaml"

const bestRegionYAMLPath = "../common-dev-assets/common-go-assets/cloudinfo-region-secmgr-prefs.yaml"

var permanentResources map[string]interface{}

func TestMain(m *testing.M) {

	var err error
	permanentResources, err = common.LoadMapFromYaml(yamlLocation)
	if err != nil {
		log.Fatal(err)
	}

	os.Exit(m.Run())
}

func setupOptions(t *testing.T, prefix string, dir string) *testhelper.TestOptions {
	options := testhelper.TestOptionsDefaultWithVars(&testhelper.TestOptions{
		Testing:            t,
		TerraformDir:       dir,
		Prefix:             prefix,
		ResourceGroup:      resourceGroup,
		BestRegionYAMLPath: bestRegionYAMLPath,
		TerraformVars: map[string]interface{}{
			"existing_sm_instance_guid":   permanentResources["secretsManagerGuid"].(string),
			"existing_sm_instance_region": permanentResources["secretsManagerRegion"].(string),
			"certificate_template_name":   permanentResources["privateCertTemplateName"].(string),
		},
	})

	return options
}

func TestRunUpgradeExample(t *testing.T) {
	t.Parallel()

	options := setupOptions(t, "sm-private-cert-upg", defaultExampleTerraformDir)

	output, err := options.RunTestUpgrade()
	if !options.UpgradeTestSkipped {
		assert.Nil(t, err, "This should not have errored")
		assert.NotNil(t, output, "Expected some output")
	}
}

func TestRunSolutionsFullyConfigurableSchematics(t *testing.T) {
	t.Parallel()

	options := testschematic.TestSchematicOptionsDefault(&testschematic.TestSchematicOptions{
		Testing: t,
		Prefix:  "sm-pc",
		TarIncludePatterns: []string{
			"*.tf",
			fullyConfigurableDir + "/*.tf",
		},
		ResourceGroup:          resourceGroup,
		TemplateFolder:         fullyConfigurableDir,
		Tags:                   []string{"test-schematic"},
		DeleteWorkspaceOnFail:  false,
		WaitJobCompleteMinutes: 80,
	})

	options.TerraformVars = []testschematic.TestSchematicTerraformVar{
		{Name: "ibmcloud_api_key", Value: options.RequiredEnvironmentVars["TF_VAR_ibmcloud_api_key"], DataType: "string", Secure: true},
		{Name: "existing_secrets_manager_crn", Value: permanentResources["secretsManagerCRN"], DataType: "string"},
		{Name: "prefix", Value: options.Prefix, DataType: "string"},
		{Name: "cert_template", Value: permanentResources["privateCertTemplateName"], DataType: "string"},
		{Name: "cert_name", Value: fmt.Sprintf("%s-cert", options.Prefix), DataType: "string"},
		{Name: "cert_common_name", Value: "terraform-modules.ibm.com", DataType: "string"},
	}

	err := options.RunSchematicTest()
	assert.Nil(t, err, "This should not have errored")
}

func TestRunSolutionsFullyConfigurableUpgradeSchematics(t *testing.T) {
	t.Parallel()

	options := testschematic.TestSchematicOptionsDefault(&testschematic.TestSchematicOptions{
		Testing: t,
		Prefix:  "sm-pc-up",
		TarIncludePatterns: []string{
			"*.tf",
			fullyConfigurableDir + "/*.tf",
		},
		ResourceGroup:          resourceGroup,
		TemplateFolder:         fullyConfigurableDir,
		Tags:                   []string{"test-schematic"},
		DeleteWorkspaceOnFail:  false,
		WaitJobCompleteMinutes: 80,
	})

	options.TerraformVars = []testschematic.TestSchematicTerraformVar{
		{Name: "ibmcloud_api_key", Value: options.RequiredEnvironmentVars["TF_VAR_ibmcloud_api_key"], DataType: "string", Secure: true},
		{Name: "existing_secrets_manager_crn", Value: permanentResources["secretsManagerCRN"], DataType: "string"},
		{Name: "prefix", Value: options.Prefix, DataType: "string"},
	}

	err := options.RunSchematicUpgradeTest()
	if !options.UpgradeTestSkipped {
		assert.Nil(t, err, "This should not have errored")
	}
}
