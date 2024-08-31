{ pkgs ? import <nixpkgs> {} }:

with pkgs;

mkShell {

  packages = with pkgs; [ 
    terraform
    kubectl
    openssl
   
    # (dbt.withAdapters (adapters: [adapters.dbt-snowflake]))
    
    (
      python311.withPackages(
        ps: with ps; let
        #   pyiceberg = buildPythonPackage rec {
      
        #     pname = "pyiceberg";
        #     version = "0.7.1 ";
        #     format = "wheel";
            
        #     src = fetchPypi {
        #       inherit pname version format;
        #       # platform = "manylinux1_x86_64";  
        #     };
        #     doCheck = false;
        # };
        pyiceberg = buildPythonPackage rec {
      
            pname = "pyiceberg";
            version = "0.7.1 ";
            format = "wheel";
            
            src = fetchurl {
              url = "https://files.pythonhosted.org/packages/0c/71/1ec3ca0537112546f2896b40142102881634e0599f04ceeade26f3bb0d76/pyiceberg-0.7.1-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
              hash = "sha256-GFbF1kGXyTNYF7jPcIHkkLYBOFYj5ReMsJTuZF1Pskw=";
            };

            dependencies = [
              psycopg2
              sqlalchemy
              python
              mmh3
              requests
              click
              rich
              strictyaml
              pydantic
              sortedcontainers
              fsspec
              pyparsing
              zstandard
              tenacity
            ];
            doCheck = false;
        };

          snowflake-connector-python = buildPythonPackage rec {
            pname = "snowflake-connector-python";
            version = "3.12.1";
            format = "wheel";

            src = fetchurl {
              url = "https://files.pythonhosted.org/packages/89/cd/0f54a69c5162bb740e0687f31db79d4f1bbed4b9cded3d73c5f37d19eba4/snowflake_connector_python-3.12.1-cp312-cp312-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
              hash = "sha256-vdxM3NmR+VOHJqfCk9Jje7Wu1D22gkbgbJLEmm3ytpI=";
            };

            dependencies = [
              asn1crypto
              certifi
              cffi
              charset-normalizer
              cryptography
              filelock
              idna
              packaging
              platformdirs
              pycparser
              pyjwt
              pyopenssl
              pytz
              requests
              sortedcontainers
              tomlkit
              typing-extensions
              urllib3
            ];
            doCheck = false;
          };
      in [
        
        ipykernel
        ipython
        jupyter
        notebook
        pyarrow
        pyiceberg

        dbt-core # for intellisense

        snowflake-connector-python

        pandas
        # minio
        # clickhouse-connect
        # sqlalchemy
        # psycopg2
      ])
    )
  ];
  shellhook = "source .env";
}