#!/bin/bash

# Skill script to generate initial feature structure.

FEATURE_NAME=$1

if [ "$1" == "--help" ] || [ "$1" == "-h" ] || [ -z "$FEATURE_NAME" ]; then
    echo "AvaloniaUI Feature Creator"
    echo "Usage: bash create_feature.sh <feature_name>"
    echo ""
    echo "Arguments:"
    echo "  feature_name       Name of the new feature in PascalCase (e.g., Reports)"
    echo ""
    echo "Example:"
    echo "  bash create_feature.sh Reports"
    
    if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
        exit 0
    else
        exit 1
    fi
fi

BASE_DIR="Src/Features/$FEATURE_NAME"
NAMESPACE="[ProjectNamespace].Src.Features.$FEATURE_NAME"

mkdir -p "$BASE_DIR/UI/FeatureStyles"
mkdir -p "$BASE_DIR/UI/FeatureComponents"
mkdir -p "$BASE_DIR/Domain"
mkdir -p "$BASE_DIR/Resources"

# 1. Create Module.cs
MODULE_FILE="$BASE_DIR/${FEATURE_NAME}Module.cs"
cat <<EOF > "$MODULE_FILE"
using Splat;
using [ProjectNamespace].Src.Infrastructure;

namespace $NAMESPACE;

public class ${FEATURE_NAME}Module : IFeatureModule
{
    public void Register(IMutableDependencyResolver services)
    {
        // Register views and view models here
        // services.Register(() => new MyView(), typeof(IViewFor<MyViewModel>));
    }
}
EOF

# 2. Create .resx file
RESX_FILE="$BASE_DIR/Resources/${FEATURE_NAME}Strings.resx"
cat <<EOF > "$RESX_FILE"
<?xml version="1.0" encoding="utf-8"?>
<root>
  <xsd:schema id="root" xmlns="" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:msdata="urn:schemas-microsoft-com:xml-msdata">
    <xsd:import namespace="http://www.w3.org/XML/1998/namespace" />
    <xsd:element name="root" msdata:IsDataSet="true">
      <xsd:complexType>
        <xsd:choice maxOccurs="unbounded">
          <xsd:element name="metadata">
            <xsd:complexType>
              <xsd:sequence>
                <xsd:element name="value" type="xsd:string" minOccurs="0" />
              </xsd:sequence>
              <xsd:attribute name="name" use="required" type="xsd:string" />
              <xsd:attribute name="type" type="xsd:string" />
              <xsd:attribute name="mimetype" type="xsd:string" />
              <xsd:attribute ref="xml:space" />
            </xsd:complexType>
          </xsd:element>
          <xsd:element name="assembly">
            <xsd:complexType>
              <xsd:attribute name="alias" type="xsd:string" />
              <xsd:attribute name="name" type="xsd:string" />
            </xsd:complexType>
          </xsd:element>
          <xsd:element name="data">
            <xsd:complexType>
              <xsd:sequence>
                <xsd:element name="value" type="xsd:string" minOccurs="0" msdata:Ordinal="1" />
                <xsd:element name="comment" type="xsd:string" minOccurs="0" msdata:Ordinal="2" />
              </xsd:sequence>
              <xsd:attribute name="name" type="xsd:string" use="required" msdata:Ordinal="0" />
              <xsd:attribute name="type" type="xsd:string" msdata:Ordinal="3" />
              <xsd:attribute name="mimetype" type="xsd:string" msdata:Ordinal="4" />
              <xsd:attribute ref="xml:space" />
            </xsd:complexType>
          </xsd:element>
          <xsd:element name="resheader">
            <xsd:complexType>
              <xsd:sequence>
                <xsd:element name="value" type="xsd:string" minOccurs="0" msdata:Ordinal="1" />
              </xsd:sequence>
              <xsd:attribute name="name" type="xsd:string" use="required" />
            </xsd:complexType>
          </xsd:element>
        </xsd:choice>
      </xsd:complexType>
    </xsd:element>
  </xsd:schema>
  <resheader name="resmimetype">
    <value>text/microsoft-resx</value>
  </resheader>
  <resheader name="version">
    <value>2.0</value>
  </resheader>
  <resheader name="reader">
    <value>System.Resources.ResXResourceReader, System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089</value>
  </resheader>
  <resheader name="writer">
    <value>System.Resources.ResXResourceWriter, System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089</value>
  </resheader>
</root>
EOF

echo "Successfully created Feature: $FEATURE_NAME"
echo "Location: $BASE_DIR"
echo "Namespace: $NAMESPACE"
