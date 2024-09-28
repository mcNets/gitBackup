# gitBack

**gitBackup** is a command line tool that allow you to create a backup of a list or repositories in a specific drive or folder.

## How to set up

1 - Get a copy of the repository.

2 - Rename the file `appsettings.json.tmp` to `appsettings.json`.

3 - Open the file `appsettings.json` and set the `BackupFolder` to the folder where you want to save the backups, and add a list of repositories that you want to backup.

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

**BackupFolder**: The folder where the backups will be saved.

**Repositories**: A list of repositories that you want to backup.

**Name**: A frienly name for the repository.

**Path**: The folder where the repository will be saved. `BackupFolder` + `Path` = `RepositoryFolder`.

**URL**: The URL of the repository.

**NOTE: You must have rights to clone the repositories.**

4 - Run the command `.\gitBackup.exe` in the root folder of the project.

---

## Linux users

If you are using Linux, you can build the project using the command `dotnet publish -c Release -r linux-x64` and then run the command `./gitBackup`. This command will require execution permission, you can set it using the command `chmod +x gitBackup`.

Open an issue if you have any problem.


