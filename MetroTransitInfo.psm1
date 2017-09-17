function Get-MTProviders{
    #GetProviders operation URI
        $providers = Invoke-RestMethod -Uri "http://svc.metrotransit.org/NexTrip/Providers"
    #GetProviders operation values
        $vproviders = $providers.ArrayOfTextValuePair.TextValuePair
    #Print
        $vproviders
        }

function Get-MTRoutes{
    #GetRoutes operation URI
        $routes = Invoke-RestMethod -Uri "http://svc.metrotransit.org/NexTrip/Routes"
    #GetRoutes operation values
        $vroutes = $routes.ArrayOfNexTripRoute.NexTripRoute
    #Print
        $vroutes
    }

function Get-MTDirections{
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
    [CmdletBinding()]
        param(
            [int[]]$RouteID,
            [string[]]$Direction
            )

    # NOTE: North = 4, South = 1, East = 2, West = 3
    If ($Direction -eq "north"){
            #GetStops operation URI
                $stops = Invoke-RestMethod -Uri ("http://svc.metrotransit.org/NexTrip/Stops/"+$RouteID+"/4")
            #GetStops operation values
                $vstops = $stops.ArrayOfTextValuePair.TextValuePair
            #Output
                $vstops
        }

    ElseIf ($Direction -eq "south"){
            #GetStops operation URI
                $stops = Invoke-RestMethod -Uri ("http://svc.metrotransit.org/NexTrip/Stops/"+$RouteID+"/1")
            #GetStops operation values
                $vstops = $stops.ArrayOfTextValuePair.TextValuePair
            #Output
                $vstops
        }
    ElseIf ($Direction -eq "east"){
            #GetStops operation URI
                $stops = Invoke-RestMethod -Uri ("http://svc.metrotransit.org/NexTrip/Stops/"+$RouteID+"/2")
            #GetStops operation values
                $vstops = $stops.ArrayOfTextValuePair.TextValuePair
            #Output
                $vstops
        }
    ElseIf ($Direction -eq "west") {
            #GetStops operation URI
                $stops = Invoke-RestMethod -Uri ("http://svc.metrotransit.org/NexTrip/Stops/"+$RouteID+"/3")
            #GetStops operation values
                $vstops = $stops.ArrayOfTextValuePair.TextValuePair
            #Output
                $vstops
        }

    }

function Get-MTDepartures{
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
    [CmdletBinding()]
        param(
            [int[]]$RouteID,
            [string[]]$Direction,
            [string[]]$Stop
            )
    If ($Direction -eq "north"){
        #GetTimepointDepartures operation URI
            $timept = Invoke-RestMethod -Uri ("http://svc.metrotransit.org/NexTrip/"+$RouteID+"/4/"+$Stop)
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
            $timept = Invoke-RestMethod -Uri ("http://svc.metrotransit.org/NexTrip/"+$RouteID+"/3/"+$Stop)
        #GetTimepointDepartures operation values
            $vtimept = $timept.ArrayOfNexTripDeparture.NexTripDeparture
        #Output
            $vtimept
        }
    ElseIf ($Direction -eq "west") {
        #GetTimepointDepartures operation URI
            $timept = Invoke-RestMethod -Uri ("http://svc.metrotransit.org/NexTrip/"+$RouteID+"/3/"+$Stop)
        #GetTimepointDepartures operation values
            $vtimept = $timept.ArrayOfNexTripDeparture.NexTripDeparture
        #Output
            $vtimept
        }
    }

# *** START MODULES BEYOND REGULAR API OUTPUT ***

function Get-MTNextBus{
    [CmdletBinding()]
        param(
            [string[]]$BusRoute,
            [string[]]$BusStop,
            [string[]]$Direction
            )
    # NOTE: North = 4, South = 1, East = 2, West = 3

    #Narrow the route listing down to our route
    $find = Get-MTRoutes | Where-Object {$_.description -like "*$BusRoute*"}

    #isolate the route number
    $rnumber = $find.route

    #get stops for the direction specified by user, and find the specific stop
    $stops = Get-MTStops -RouteID $rnumber -Direction $Direction | Where-Object {$_.text -like "*$BusStop*"}
  
    #isolate stop value
    $rstops = $stops.value

    #find timepoint departures
    $tdepart = Get-MTTimepointDepartures -RouteID $rnumber -Direction $Direction -Stop $rstops

    #get current time and format it to Hour:Minute
    $ctime = Get-Date -UFormat "%H:%M"

    #narrow results down to only departures that are after the current time, and grab only the first one
    $selecttdepart = $tdepart | Where-Object {$_.departuretext -gt $ctime} | Select-Object -First 1

    #narrow that information down to just the departure time
    $dtime = $selecttdepart.departuretext

    If ($dtime -like "*min*"){
        Write-Output "The next departure will be in $dtime."
        }
    ElseIf ($dtime -like "*due*"){
        Write-Output "The next departure is due right now."
        }
    else {
        #create new time span to get info on how many minutes to the next departure
        $newTspan = New-TimeSpan -Start $ctime -End $dtime

        #select only the minute output of the time span
        $rnewTspan = $newTspan.Minutes

            #output completed results!
        if ($rnewTspan -gt 1){
            Write-Output "The next departure will be in $rnewTspan minutes."
            }
        ElseIf ($rnewTspan -eq 1) {
            Write-Output "The next departure will be in $rnewTspan minute."
            }
        Else {
            Write-Output "There are no more busses/trains on this route departing from the specified location today."
        }

    }

}
