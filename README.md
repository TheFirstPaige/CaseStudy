# CaseStudy

## Overview

#### Problem
Using the API available at http://svc.metrotransit.org/, create a program that will allow a user to see how long until the next bus/train on a route will leave a specified stop. This can be completed by using any language of your choice. 

#### Solution
In this example, I have chosen to create a PowerShell module that can be used to explore tha API freely and utilize a specific function that will provide the answer requested in the problem.

## Prerequisites
#### Powershell Version Requirements
This module was created using Powershell version 5, but should be functional on version 3 or later
  *Version can be checked through $PSVersionTable

#### Powershell Execution Requirements
Because this module has not been signed, on of two work arounds will need to be impleemented to be able to use this module properly.

In order to import the module, the execution policy will need to be set to unrestricted. You can use the following command to set this policy, but it must be run as an administrator:
```
Set-ExecutionPolicy Unrestricted
```

If you do not want to set your execution policy to unrestricted you can open ISE on your local machine, copy the contents of the MetroTransitTools.psm1 file and paste them into the ISE window, then save it as a .psm1 file. For this to work, your execution poilcy will need to be set to remote signed:
```
Set-ExecutionPolicy RemoteSigned
```
## Module Implementation
Once prerequisite requirements have been met, the module can be imported. The .psm1 file will need to be placed in the $HOME\Documents\WindowsPowerShell\Modules\MetroTransitTools\ directory. In order to create these folders if they do not already exist, complete the following:
```
New-Item -Path $HOME\Documents\ -ItemType directory -Name WindowsPowerShell\Modules\MetroTransitTools\
``` 
Once the .psm1 file is in the required location, simply import the MetroTransiInfo module via the following command:
```
Import-Module $HOME\Documents\WindowsPowerShell\Modules\MetroTransitTools\MetroTransitInfo.psm1
```
## Solution Implementation
In order to get the information that the problem requests, we can simply use the Get-MTNextBus cmdlet that has been made available through the MetroTransitInfo module. The user will need to provide a bus route (using -BusRoute), a stop location (using -Stop), and a direction (using -Direction). Below is an example command and output:
```
PS C:\> Get-MTNextBus -BusRoute "METRO Blue Line" -BusStop "Mall of America Station" -Direction "South"
The next departure will be in 17 Min.
```

## Solution Testing
I've provided four tests for the usage of this module - these commands can be copied/pasted into your PowerShell console after the module has been properly imported. Note that the creation of variables is used only for ease of testing. Users can put the property values directly into the cmdlet as seen in the "Solution Implementation" section of this README.md file. 

#### Test I
Test commands:
```
$BusRoute = "METRO Blue Line"
$BusStop = "Mall of America Station"
$Direction = "South"
Get-MTNextBus -BusRoute $BusRoute -BusStop $BusStop -Direction $Direction
```
Test output:
```
PS C:\> $BusRoute = "METRO Blue Line"
PS C:\> $BusStop = "Mall of America Station"
PS C:\> $Direcion = "South"
PS C:\> Get-MTNextBus -BusRoute $BusRoute -BusStop $BusStop -Direction $Direcion
The next departure will be in 17 Min.
```

#### Test II
Test commands:
```
$BusRoute = "Robbinsdale-West Broadway-Bloomington Av"
$BusStop = "Courage Center"
$Direction = "North"
Get-MTNextBus -BusRoute $BusRoute -BusStop $BusStop -Direction $Direction
```
Test output:
```
PS C:\> $BusRoute = "Robbinsdale-West Broadway-Bloomington Av"
PS C:\> $BusStop = "Courage Center"
PS C:\> $Direction = "North"
PS C:\> Get-MTNextBus -BusRoute $BusRoute -BusStop $BusStop -Direction $Direction
The next departure will be in 4 Min.
```
#### Test III
Test commands:
```
$BusRoute = "Edina - Richfield - 77th St - MOA"
$BusStop = "Minnesota Dr and France Ave"
$Direction = "East"
Get-MTNextBus -BusRoute $BusRoute -BusStop $BusStop -Direction $Direction
```
Test output:
```
PS C:\> $BusRoute = "Edina - Richfield - 77th St - MOA"
PS C:\> $BusStop = "Minnesota Dr and France Ave"
PS C:\> $Direction = "East"
PS C:\> Get-MTNextBus -BusRoute $BusRoute -BusStop $BusStop -Direction $Direction
The next departure will be in 11 minutes.
```

#### Test IV
Test commands:
```
$BusRoute = "W Minnehaha - Raymond Sta - Hiawatha"
$BusStop = "Minnehaha Ave and Snelling Ave"
$Direction = "West"
Get-MTNextBus -BusRoute $BusRoute -BusStop $BusStop -Direction $Direction
```
Test output:
```
PS C:\> $BusRoute = "W Minnehaha - Raymond Sta - Hiawatha"
PS C:\> $BusStop = "Minnehaha Ave and Snelling Ave"
PS C:\> $Direction = "West"
PS C:\> Get-MTNextBus -BusRoute $BusRoute -BusStop $BusStop -Direction $Direction
The next departure will be in 20 minutes.
```
## Acknowledgments

Thank you to GitHub user, Billie Thompson. This README.md was constructed using the template made available here: https://gist.github.com/PurpleBooth/109311bb0361f32d87a2
