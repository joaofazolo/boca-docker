# Build matrix for GitHub Actions

The JSON file(s) in this folder will be read in the GitHub Actions workflows and used as shown below.

:warning: Edit the `matrix.json` file to add/remove supported image releases/tags (e.g., boca-web:1.2.0). **Untagged or unsupported images will be deleted periodically.** :warning:

```yml
jobs:
  setup:
    runs-on: ubuntu-latest
    outputs:
      parent: ${{ steps.set-matrix.outputs.parent }}

    steps:
      - 
        name: Checkout repository
        uses: actions/checkout@v3

      - 
        id: set-json
        name: Get build matrix from file
        run: |

          # Specify path of matrix file
          JSON=docker/build/matrix.json
          echo "json=${JSON}" >> $GITHUB_OUTPUT
          echo ${JSON}

      - 
        id: set-matrix
        name: Set build matrix of releases, parent images and os/architectures
        run: |

          # Read matrix from file and set variables
          CONTENT=`cat ${{ steps.set-json.outputs.json }}`
          echo $CONTENT
          PARENTS=$(echo $CONTENT | jq ".parent")
          echo $PARENTS

          # Passing matrix between jobs and/or workflows
          echo "parent="${PARENTS} >> "$GITHUB_OUTPUT"

  check-setup:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        parent: ${{ fromJSON(needs.setup.outputs.parent) }}
    needs:
      - setup
```
