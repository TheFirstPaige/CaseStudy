# CaseStudy

## Overview

#### Problem
Using the API available at http://svc.metrotransit.org/, create a program that will allow a user to see how long until the next bus/train on a route will leave a specified stop. This can be completed by using any language of your choice. 

#### Solution
In this example, I have chosen to create a PowerShell module that can be used to explore tha API freely and utilize a specific function that will provide the answer requested in the problem.

## Prerequisites
*This module was created using Powershell version 5, but should be functional on version 3 or later
  *Version can be checked through $PSVersionTable

*Because this module has not been signed, on of two work arounds will need to be impleemented to be able to use this module properly.

*In order to import the module, the execution policy will need to be set to unrestricted. You can use the following command to set this policy, but it must be run as an administrator:
```
Set-ExecutionPolicy Unrestricted
```

*If you do not want to set your execution policy to unrestricted you can open ISE, copy the contents of the MetroTransitTools.psm1 file and paste them into the ISE window, then save it as a .psm1 file. For this to work, your execution poilcy will need to be set to remote signed:
```
Set-ExecutionPolicy RemoteSigned
```


## Acknowledgments

Thank you to GitHub user, Billie Thompson. This README.md was constructed using the template made available here: https://gist.github.com/PurpleBooth/109311bb0361f32d87a2
