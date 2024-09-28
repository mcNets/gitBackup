# gitBackup

![net9.0](https://img.shields.io/badge/net-9.0-blue)

**Windows** | **Linux** | **macOS**

**gitBackup** is a command-line tool that allows you to create backups of a list of repositories in a specified drive or folder. The tool checks if there is an existing repository in the specified folder and updates it. If there is no repository, the tool clones it, otherwise, it pull the latest changes and updates the repository.

    NOTE: You must have the necessary permissions to clone the repositories.

## Setup Instructions

1. Clone or download a copy of this repository.

2. Rename the file `appsettings.json.tmp` to `appsettings.json`.

3. Open the `appsettings.json` file and configure the following:

    - **BackupFolder**: Set this to the folder where you want the backups to be stored.
    - **Repositories**: Add the list of repositories you want to back up.

Here's an example of the `appsettings.json` file:

```json
{
    "AppSettings": {
        "BackupFolder": "C:\\\\GitBackup\\"
    },
    "Repositories": [
        {
            "Name": "MyRepo1",
            "Path": "MyRepo1",
            "URL": "https://github.com/mcNets/MyRepo1"
        },
        {
            "Name": "Osmo",
            "Path": "Osmo",
            "URL": "https://company.visualstudio.com/MyRepo2/_git/MyRepo2"
        }
    ]
}
```

### Configuration Fields:

- **BackupFolder**: The directory where backups will be stored.
- **Repositories**: A list of repositories to be backed up.
    - **Name**: A friendly name for the repository.
    - **Path**: The folder where the repository will be saved (e.g., `BackupFolder` + `Path` = `RepositoryFolder`).
    - **URL**: The repository’s URL.


4. Run the command `.\gitBackup.exe` in the project's root directory to start the backup process.

---

## For Linux Users

Grant write permissions to the folder where you want to store the backups. You can do this with the following command:

```bash
sudo chmod -R 777 /path/to/your/folder
```

If you're using Linux, you can build the project with the following command:

```bash
dotnet publish -c Release -r linux-x64
```

Make sure the file has execution permissions. You can grant these permissions with:

```bash
chmod +x gitBackup
```
After building, run the tool with:
    
```bash
./gitBackup
```

Open an issue if you have any problem.


