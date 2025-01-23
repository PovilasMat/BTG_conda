#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "alias conda=micromamba" >> ~/.bashrc
cat "$SCRIPT_DIR"/mambarc >> ~/.mambarc

ls -1F "$SCRIPT_DIR" | grep ".yaml" > "$SCRIPT_DIR"/list_of_conda_envs.txt

(while read -r LINE; do
  grep "name:" "$SCRIPT_DIR"/"$LINE" >> "$SCRIPT_DIR"/names_of_conda_envs.txt
done < "$SCRIPT_DIR"/list_of_conda_envs.txt)

sed -i 's/name: //g' "$SCRIPT_DIR"/names_of_conda_envs.txt
(while read -r LINE; do
  ~/.local/bin/micromamba create -f /home/gebt/BTG_2024/conda_envs/$LINE -y
done < "$SCRIPT_DIR"/list_of_conda_envs.txt)

echo "List of all envs that should have been created:"
cat "$SCRIPT_DIR"/names_of_conda_envs.txt
echo "Number of envs that should be created"
wc -l "$SCRIPT_DIR"/names_of_conda_envs.txt

~/.local/bin/micromamba env list | sort > "$SCRIPT_DIR"/existing_conda_envs.txt
echo "List of all envs that were created:"
(while read -r LINE; do
    if grep -q "$LINE" "$SCRIPT_DIR"/existing_conda_envs.txt; then
        echo "$LINE" >> "$SCRIPT_DIR"
        echo "$LINE" >> "$SCRIPT_DIR"/matching_conda_envs.txt
    fi
done < "$SCRIPT_DIR"/names_of_conda_envs.txt)
echo "Number of envs that were created:"
wc -l "$SCRIPT_DIR"/matching_conda_envs.txt

rm "$SCRIPT_DIR"/list_of_conda_envs.txt
rm "$SCRIPT_DIR"/names_of_conda_envs.txt
rm "$SCRIPT_DIR"/existing_conda_envs.txt
rm "$SCRIPT_DIR"/matching_conda_envs.txt
