
# Invoke-PixelScript

Invoke-PixelScript is a PowerShell module designed to embed PowerShell scripts within the pixels of an image file (PNG). This module provides a way to execute hidden scripts from these images, effectively using steganography to conceal and transport PowerShell scripts.

## Features

- **Embed Scripts in Images**: Hide PowerShell scripts in the least significant bits of image pixels.
- **Execute from Image**: Generate a one-liner to execute the embedded script directly from the image.

## Prerequisites

Before you begin using Invoke-PixelScript, ensure you have PowerShell installed on your system. This module also requires the .NET System.Drawing assembly, typically available by default in Windows environments.

## Installation

```powershell
# Install the module
Install-Module PsInPic

# Import the module
Import-Module PsInPic
```

## Usage

### Embedding a Script into an Image

To embed a PowerShell script into an image, you can use the `Invoke-PixelScript` function.

```
PARAMETERS

$Script   - path to .ps1 script you want to embed 
$Image    - path to the image you plan to use
$Out      - path to the output file
$ExecPath - path to where you anticipate running the script from the targets computer 
            (can be altered whenever and will default to $Out if nothing is provided)
```

```powershell
# Embed a script into an existing image and save the output
$payload = Invoke-PixelScript -Script "C:\path\to\script.ps1" -Image "C:\path\to\image.png" -Out "C:\path\to\output.png" -ExecPath "C:\path\to\output.png"
```

### Generating the Execution Command

After embedding, the function returns a PowerShell one-liner that you can use to execute the script directly from the image:

```powershell
# Execute the embedded script from the image
Invoke-Expression $payload
```

## Contributing

Contributions to the Invoke-PixelScript project are welcome! Please feel free to fork the repository, make your changes, and submit a pull request.

