#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: make dir=</path/to/plugin>"
    exit 1;
fi

DIRECTORY="$1"
DIRECTORY=${DIRECTORY%/}  # Trim trailing slash
COMPOSER_LOCK="$DIRECTORY/composer.lock"
THIRD_PARTY_LIBS="$DIRECTORY/thirdpartylibs.xml"

if [ ! -f "$COMPOSER_LOCK" ]; then
    echo "composer.lock not found in $DIRECTORY"
    exit 1
fi

echo '<?xml version="1.0"?>
<libraries>' > "$THIRD_PARTY_LIBS"

# Getting the Composer version
COMPOSER_VERSION=$(composer --version | awk '{print $3}')

{
    echo "    <library>"
    echo "        <location>vendor/autoload.php</location>"
    echo "        <name>autoload.php</name>"
    echo "        <version>$COMPOSER_VERSION</version>"
    echo "        <license>MIT</license>"
    echo "    </library>"
    echo "    <library>"
    echo "        <location>vendor/composer</location>"
    echo "        <name>composer</name>"
    echo "        <version>$COMPOSER_VERSION</version>"
    echo "        <license>MIT</license>"
    echo "    </library>"
}  >> "$THIRD_PARTY_LIBS"

# Parse the composer.lock file and extract required information
packages=$(jq -c '.packages[] | {name: .name, version: .version, license: .license, licenseversion: .licenseversion}' < "$COMPOSER_LOCK")

echo "$packages" | while IFS= read -r package; do
    name=$(jq -r '.name' <<< "$package")
    version=$(jq -r '.version' <<< "$package")
    license=$(jq -r '.license | if type == "array" then join(", ") else . end' <<< "$package")

    {
        echo "    <library>"
        echo "        <location>vendor/$name</location>"
        echo "        <name>$name</name>"
        echo "        <version>$version</version>"
        echo "        <license>$license</license>"
        echo "    </library>"
    } >> "$THIRD_PARTY_LIBS"
done

echo '</libraries>' >> "$THIRD_PARTY_LIBS"

echo "thirdpartylibs.xml generated."