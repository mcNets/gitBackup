Console.Clear();

// get current version from assembly
var version = System.Reflection.Assembly.GetExecutingAssembly().GetName().Version;
Console.ForegroundColor = ConsoleColor.Green;
Console.WriteLine($"gitBackup Ver. {version?.Major}.{version?.Minor}.{version?.Build}");
Console.ResetColor();

// check if appsettings.json exists
if (File.Exists("appsettings.json") == false)
{
    Console.ForegroundColor = ConsoleColor.Red;
    Console.WriteLine("appsettings.json not found");
    Console.WriteLine("Follow the instructions in README.md to create the file");
    Console.WriteLine("https://github.com/mcNets/gitBackup");
    Console.ResetColor();
    return;
}

// access to appsettings.json
var configuration = new ConfigurationBuilder()
    .SetBasePath(Directory.GetCurrentDirectory())
    .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true)
    .Build();

var backupFolder = configuration["AppSettings:BackupFolder"];
var repositories = configuration.GetSection("Repositories")
    .GetChildren()
    .Select(x => new Repository(x["Name"], x["Path"], x["Url"]))
    .ToList();

Console.WriteLine($"BackupFolder: {backupFolder}");

// make sure the backup folder exists
Console.WriteLine($"Checking backup folder: {backupFolder}\n");
ArgumentNullException.ThrowIfNull(backupFolder, "BackupFolder");
if (Directory.Exists(backupFolder) == false)
{
    Directory.CreateDirectory(backupFolder);
    if (!Directory.Exists(backupFolder))
    {
        Console.ForegroundColor = ConsoleColor.Red;
        Console.WriteLine($"Failed to create backup folder: {backupFolder}");
        Console.ResetColor();
        return;
    }
}

// backup each repository
foreach (var repository in repositories)
{
    Console.WriteLine($"Backing up repository: {repository.Name}");
    ArgumentNullException.ThrowIfNull(repository.Name, "Name");
    ArgumentNullException.ThrowIfNull(repository.Path, "Path");
    ArgumentNullException.ThrowIfNull(repository.Url, "Url");

    var startInfo = new ProcessStartInfo
    {
        FileName = "git",
        RedirectStandardOutput = true,
        RedirectStandardError = true,
        UseShellExecute = false,
        CreateNoWindow = true
    };

    // if backup repo exist, git pull else git clone
    var backupPath = Path.Combine(backupFolder, repository.Path);
    if (Directory.Exists(backupPath) == false)
    {
        startInfo.Arguments = $"clone {repository.Url} {Path.Combine(backupFolder, repository.Path)}";
    }
    else
    {
        startInfo.Arguments = $"-C {backupPath} pull";
    }

    var process = new Process
    {
        StartInfo = startInfo
    };

    bool result = process.Start();
    process.WaitForExit();

    Console.Write(process.StandardOutput.ReadToEnd());

    if (process.ExitCode == 0)
    {
        Console.ForegroundColor = ConsoleColor.Green;
        Console.WriteLine($"Backup {repository.Name} completed successfully\n");
    }
    else
    {
        Console.ForegroundColor = ConsoleColor.Red;
        Console.Write(process.StandardError.ReadToEnd());
    }
    Console.ResetColor();
}