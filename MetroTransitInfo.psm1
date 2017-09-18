function Get-MTProviders{
<#
.SYNOPSIS
    Information gathered from http://svc.metrotransit.org/
    "Returns a list of area Transit providers. Providers are identified in the list of Routes allowing routes to be selected for a single provider."
.DESCRIPTION
    Get-MTProviders queries http://svc.metrotransit.org/NexTrip/Providers for information on Metro Transit providers.
#>
    #GetProviders operation URI
        $providers = Invoke-RestMethod -Uri "http://svc.metrotransit.org/NexTrip/Providers"
    #GetProviders operation values
        $vproviders = $providers.ArrayOfTextValuePair.TextValuePair
    #Print
        $vproviders
        }

function Get-MTRoutes{
<#
.SYNOPSIS
    Information gathered from http://svc.metrotransit.org/
    "Returns a list of Transit routes that are in service on the current day."
.DESCRIPTION
    Get-MTRoutes queries http://svc.metrotransit.org/NexTrip/Routes for information on Metro Transit routes.
#>
    #GetRoutes operation URI
        $routes = Invoke-RestMethod -Uri "http://svc.metrotransit.org/NexTrip/Routes"
    #GetRoutes operation values
        $vroutes = $routes.ArrayOfNexTripRoute.NexTripRoute
    #Print
        $vroutes
    }

function Get-MTDirections{
<#
.SYNOPSIS
    Information gathered from http://svc.metrotransit.org/
    "Returns the two directions that are valid for a given route. Either North/South or East/West."
.DESCRIPTION
    Get-MTDirections queries http://svc.metrotransit.org/NexTrip/Directions/{ROUTE} for information on which directions the route runs.
#>
    [CmdletBinding()]
        param(
            [int[]]$RouteID
            )
    #GetDirections operation URI
        $directions = Invoke-RestMethod -Uri ("http://svc.metrotransit.org/NexTrip/Directions/"+$routeid)
    #GetDirections operation values
        $vdirections = $directions.ArrayOfTextValuePair.TextValuePair
    #Print
        $vdirections
    }

function Get-MTStops{
<#
.SYNOPSIS
    Information gathered from http://svc.metrotransit.org/
    "Returns a list of Timepoint stops for the given Route/Direction."
.DESCRIPTION
    Get-MTStops queries http://svc.metrotransit.org/NexTrip/Stops/{ROUTE}/{DIRECTION} for information on route stops.
#>
    [CmdletBinding()]
        param(
            [int[]]$RouteID,
            [string[]]$Direction
            )

    # NOTE: North = 4, South = 1, East = 2, West = 3
    If ($Direction -eq "north"){
            #GetStops operation URI
                $stops = Invoke-RestMethod -Uri ("http://svc.metrotransit.org/NexTrip/Stops/$RouteID/4")
            #GetStops operation values
                $vstops = $stops.ArrayOfTextValuePair.TextValuePair
            #Output
                $vstops
        }

    ElseIf ($Direction -eq "south"){
            #GetStops operation URI
                $stops = Invoke-RestMethod -Uri ("http://svc.metrotransit.org/NexTrip/Stops/$RouteID/1")
            #GetStops operation values
                $vstops = $stops.ArrayOfTextValuePair.TextValuePair
            #Output
                $vstops
        }
    ElseIf ($Direction -eq "east"){
            #GetStops operation URI
                $stops = Invoke-RestMethod -Uri ("http://svc.metrotransit.org/NexTrip/Stops/$RouteID/2")
            #GetStops operation values
                $vstops = $stops.ArrayOfTextValuePair.TextValuePair
            #Output
                $vstops
        }
    ElseIf ($Direction -eq "west") {
            #GetStops operation URI
                $stops = Invoke-RestMethod -Uri ("http://svc.metrotransit.org/NexTrip/Stops/$RouteID/3")
            #GetStops operation values
                $vstops = $stops.ArrayOfTextValuePair.TextValuePair
            #Output
                $vstops
        }

    }

function Get-MTDepartures{
<#
.SYNOPSIS
    Information gathered from http://svc.metrotransit.org/
    "This operation is used to return a list of departures scheduled for any given bus stop."
.DESCRIPTION
    Get-MTDepartures queries http://svc.metrotransit.org/NexTrip/{STOPID} for information on departures.
#>
    [CmdletBinding()]
        param(
            [int[]]$StopID
            )
    #GetDirections operation URI
    # *** NOTE that StopID is equivalent to the block numbers in the GET-MTTimepointDepartures output ***
        $departures = Invoke-RestMethod -Uri ("http://svc.metrotransit.org/NexTrip/"+$StopID)
    #GetDirections operation values
        $vdepartures = $departures.ArrayOfTextValuePair.TextValuePair
    #Print
        $departures.ArrayOfNexTripDeparture.NexTripDeparture
    }

function Get-MTTimepointDepartures{
<#
.SYNOPSIS
    Information gathered from http://svc.metrotransit.org/
    "Returns the scheduled departures for a selected route, direction and timepoint stop."
.DESCRIPTION
    Get-MTTimepointDepartures queries http://svc.metrotransit.org/NexTrip/{ROUTE}/{DIRECTION}/{STOP} for information on route departures from a specified stop.
#>
    [CmdletBinding()]
        param(
            [int[]]$RouteID,
            [string[]]$Direction,
            [string[]]$Stop
            )
    If ($Direction -eq "north"){
        #GetTimepointDepartures operation URI
            $timept = Invoke-RestMethod -Uri ("http://svc.metrotransit.org/NexTrip/$RouteID/4/$Stop")
        #GetTimepointDepartures operation values
            $vtimept = $timept.ArrayOfNexTripDeparture.NexTripDeparture
        #Output
            $vtimept
        }

    ElseIf ($Direction -eq "south"){
        #GetTimepointDepartures operation URI
            $timept = Invoke-RestMethod -Uri ("http://svc.metrotransit.org/NexTrip/$RouteID/1/$Stop")
        #GetTimepointDepartures operation values
            $vtimept = $timept.ArrayOfNexTripDeparture.NexTripDeparture
        #Output
            $vtimept
        }
    ElseIf ($Direction -eq "east"){
        #GetTimepointDepartures operation URI
            $timept = Invoke-RestMethod -Uri ("http://svc.metrotransit.org/NexTrip/$RouteID/2/$Stop")
        #GetTimepointDepartures operation values
            $vtimept = $timept.ArrayOfNexTripDeparture.NexTripDeparture
        #Output
            $vtimept
        }
    ElseIf ($Direction -eq "west") {
        #GetTimepointDepartures operation URI
            $timept = Invoke-RestMethod -Uri ("http://svc.metrotransit.org/NexTrip/$RouteID/3/$Stop")
        #GetTimepointDepartures operation values
            $vtimept = $timept.ArrayOfNexTripDeparture.NexTripDeparture
        #Output
            $vtimept
        }
    }

# *** START MODULES BEYOND REGULAR API OUTPUT ***

function Get-MTNextBus{
<#
.SYNOPSIS
    This function provides information on the next departure time for a route from a specified bus stop
.DESCRIPTION
    Get-MTNextBus uses information from the other functions in the MetroTransitInfo module to determine when the next bus/train leaves the specified stop for a certain route.
#>
    [CmdletBinding()]
        param(
            [string[]]$BusRoute,
            [string[]]$BusStop,
            [string[]]$Direction
            )
    # NOTE: North = 4, South = 1, East = 2, West = 3

    #Narrow the route listing down to our route
    $find = Get-MTRoutes | Where-Object {$_.description -like "*$BusRoute*"} -ErrorAction Ignore

    #isolate the route number
    $rnumber = $find.route

    #get stops for the direction specified by user, and find the specific stop
    $stops = Get-MTStops -RouteID $rnumber -Direction $Direction | Where-Object {$_.text -like "*$BusStop*"} -ErrorAction Ignore
  
    #isolate stop value
    $rstops = $stops.value

    #find timepoint departures
    $tdepart = Get-MTTimepointDepartures -RouteID $rnumber -Direction $Direction -Stop $rstops -ErrorAction Ignore

    If ($tdepart -ne $null) {
        #get current time and format it to Hour:Minute:Second
        $ctime = Get-Date -UFormat "%H:%M:%S"

        #narrow results down to only departures that are after the current time, and grab only the first one
        $selecttdepart = $tdepart | Select-Object -First 1 -ErrorAction Ignore

        #narrow that information down to just the departure time
        $dtime = $selecttdepart.departuretime.substring(11)

        $newTspan = New-TimeSpan -Start $ctime -End $dtime -ErrorAction Ignore

        #select only the minute output of the time span
        $rnewTspan = $newTspan.Minutes

        If ($rnewTspan -gt 1){
            Write-Output "The next departure will be in $rnewTspan minutes." -ErrorAction Ignore
            }
        ElseIf ($rnewTspan -eq 1) {
            Write-Output "The next departure will be in $rnewTspan minute." -ErrorAction Ignore
            }
        }
    }
