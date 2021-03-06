function AddOrUpdate-Reference($scriptsFolderProjectItem, $fileNamePattern, $newFileName) {
    try {
        $referencesFileProjectItem = $scriptsFolderProjectItem.ProjectItems.Item("_references.js")
    }
    catch {
        # _references.js file not found
        return
    }

    if ($referencesFileProjectItem -eq $null) {
        # _references.js file not found
        return
    }

    $referencesFilePath = $referencesFileProjectItem.FileNames(1)
    $referencesTempFilePath = Join-Path $env:TEMP "_references.tmp.js"

    if ((Select-String $referencesFilePath -pattern $fileNamePattern).Length -eq 0) {
        # File has no existing matching reference line
        # Add the full reference line to the beginning of the file
        "/// <reference path=""$newFileName"" />" | Add-Content $referencesTempFilePath -Encoding UTF8
         Get-Content $referencesFilePath | Add-Content $referencesTempFilePath
    }
    else {
        # Loop through file and replace old file name with new file name
        Get-Content $referencesFilePath | ForEach-Object { $_ -replace $fileNamePattern, $newFileName } > $referencesTempFilePath
    }

    # Copy over the new _references.js file
    Copy-Item $referencesTempFilePath $referencesFilePath -Force
    Remove-Item $referencesTempFilePath -Force
}

function Remove-Reference($scriptsFolderProjectItem, $fileNamePattern) {
    try {
        $referencesFileProjectItem = $scriptsFolderProjectItem.ProjectItems.Item("_references.js")
    }
    catch {
        # _references.js file not found
        return
    }

    if ($referencesFileProjectItem -eq $null) {
        return
    }

    $referencesFilePath = $referencesFileProjectItem.FileNames(1)
    $referencesTempFilePath = Join-Path $env:TEMP "_references.tmp.js"

    if ((Select-String $referencesFilePath -pattern $fileNamePattern).Length -eq 1) {
        # Delete the line referencing the file
        Get-Content $referencesFilePath | ForEach-Object { if (-not ($_ -match $fileNamePattern)) { $_ } } > $referencesTempFilePath

        # Copy over the new _references.js file
        Copy-Item $referencesTempFilePath $referencesFilePath -Force
        Remove-Item $referencesTempFilePath -Force
    }
}

# Identify the parent directory for the currently running script
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition

# Then dot source the options
. (Join-Path $scriptPath opts.ps1)

# Identify the parent directory for the currently running script
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition

# Then dot source the options
. (Join-Path $scriptPath opts.ps1)

# Should have a prefix sourced from the options
$cssPrefix = $jsPrefix = Get-Prefix
# Extract the version number from the file in the package's $(ProjectDir)scripts\testfixturejs folder
$packageScriptsFolder = Join-Path $installPath Content\Scripts\TestFixtureJS
# $(ProjectDir)content\testfixturejs
$packageContentFolder = Join-Path $installPath Content\Content\TestFixtureJS
# prefix is signaled from the opts and is the only thing that needs to change from script to script for this particular packaging
$jsFileName = $jsPrefix + "*.js"
$jsFilePath = Join-Path $packageScriptsFolder $jsFileName | Get-ChildItem -Exclude "*.min.js", "*-vsdoc.js" | Split-Path -Leaf
$cssFilePath = Join-Path $packageContentFolder $cssFileName | Get-ChildItem -Exclude "*.min.css" | Split-Path -Leaf
$jsFileNameRegEx = $jsPrefix + "((?:\d+\.)?(?:\d+\.)?(?:\d+\.)?(?:\d+)?(?:(?:-\w*)*)).js"
$cssFileNameRegEx = $cssPrefix + "((?:\d+\.)?(?:\d+\.)?(?:\d+\.)?(?:\d+)?(?:(?:-\w*)*)).css"
$matches = $jsFilePath -match $jsFileNameRegEx
# Write-Output $jsPrefix $jsFileName $jsFilePath $jsFileNameRegEx $matches
$ver = $matches[1]

# Get the project item for the scripts folder
try {
    $scriptsFolderProjectItem = $project.ProjectItems.Item("Scripts")
    $projectScriptsFolderPath = $scriptsFolderProjectItem.FileNames(1)
    $contentFolderProjectItem = $project.ProjectItems.Item("Content")
    $projectContentFolderPath = $contentFolderProjectItem.FileNames(1)
}
catch {
    # No Scripts folder
    Write-Host "No scripts folder found"
}