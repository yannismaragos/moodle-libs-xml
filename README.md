# Moodle-Libs-XML

Generates the file `thirdpartylibs.xml` from a given Composer lock file.

## Usage

### Requirements

- [jq](https://stedolan.github.io/jq/) installed

### Steps

1. Ensure `jq` is installed in your system.
2. Clone/download the tool.
3. Run the following command from the terminal, specifying the path to your plugin directory:

    ```bash
    make dir="/path/to/plugin"
    ```

Replace `/path/to/plugin` with the path to your specific plugin directory.

## Script Explanation

- **Makefile:** Defines the default goal as `generate_thirdpartylibs_xml`, which executes the `generate_libs.sh` script.
- **Shell Script (`generate_libs.sh`):**
    - Takes the plugin directory path as a parameter.
    - Validates if the `composer.lock` file exists in the provided directory.
    - Generates an XML file (`thirdpartylibs.xml`) containing details of third-party libraries.
    - Utilizes `jq` to parse the `composer.lock` file, extracting the required package information.

## Output

The script will generate an `XML` file named `thirdpartylibs.xml` in the specified plugin directory.
