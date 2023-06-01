// Tests in this file are run in the PR pipeline
package test

import (
	"log"
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
	"gopkg.in/yaml.v3"
)

const resourceGroup = "geretain-test-resources"
const terraformDir = "examples/default"

// Define a struct with fields that match the structure of the YAML data
const yamlLocation = "../common-dev-assets/common-go-assets/common-permanent-resources.yaml"

type Config struct {
	SmGuid                  string `yaml:"secretsManagerGuid"`
	SmRegion                string `yaml:"secretsManagerRegion"`
	CertificateTemplateName string `yaml:"privateCertTemplateName"`
}

var smGuid string
var smRegion string
var certificateTemplateName string

// TestMain will be run before any parallel tests, used to read data from yaml for use with tests
func TestMain(m *testing.M) {
	// Read the YAML file contents
	data, err := os.ReadFile(yamlLocation)
	if err != nil {
		log.Fatal(err)
	}
	// Create a struct to hold the YAML data
	var config Config
	// Unmarshal the YAML data into the struct
	err = yaml.Unmarshal(data, &config)
	if err != nil {
		log.Fatal(err)
	}
	// Parse the SM guid and region from data
	smGuid = config.SmGuid
	smRegion = config.SmRegion
	certificateTemplateName = config.CertificateTemplateName
	os.Exit(m.Run())
}

func setupOptions(t *testing.T, prefix string, dir string) *testhelper.TestOptions {

	options := testhelper.TestOptionsDefaultWithVars(&testhelper.TestOptions{
		Testing:       t,
		TerraformDir:  dir,
		Prefix:        prefix,
		ResourceGroup: resourceGroup,
		TerraformVars: map[string]interface{}{
			"existing_sm_instance_guid":   smGuid,
			"existing_sm_instance_region": smRegion,
			"certificate_template_name":   certificateTemplateName,
		},
	})

	return options
}

func TestRunDefaultExample(t *testing.T) {
	t.Parallel()

	options := setupOptions(t, "sm-private-cert", terraformDir)

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

func TestRunUpgradeExample(t *testing.T) {
	t.Parallel()

	options := setupOptions(t, "sm-private-cert-upg", terraformDir)

	output, err := options.RunTestUpgrade()
	if !options.UpgradeTestSkipped {
		assert.Nil(t, err, "This should not have errored")
		assert.NotNil(t, output, "Expected some output")
	}
}
