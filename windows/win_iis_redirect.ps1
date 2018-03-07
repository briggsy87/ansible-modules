#!powershell
# This file is part of Ansible
#
# (c) 2018, Kyle Briggs <briggsy87@gmail.com>
#
# Ansible is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ansible is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ansible.  If not, see <http://www.gnu.org/licenses/>.

# WANT_JSON
# POWERSHELL_COMMON

$ErrorActionPreference = 'Stop'
$VerbosePreference = 'Continue'

$params = Parse-Args -arguments $args -supports_check_mode $true
$sitename = Get-AnsibleParam $params -name "site_name" -default "IIS:\sites\Default Web Site"
$http_redirect = @{
  enabled = (Get-AnsibleParam $params -name "enabled" -default "true"-validateSet "true","false")
  child_only = (Get-AnsibleParam $params "child_only" -default "false" -validateSet "true","false")
  exact_destination = (Get-AnsibleParam $params -name "exact_destination" -default "false" -validateSet "true","false")
  destination = (Get-AnsibleParam $params -name "destination" -failifempty $true)
  http_response_status = (Get-AnsibleParam $params -name "http_response_status" -default "Found" -validateSet "Found","Permanent","Temporary","Permanent Redirect")
};

# Ensure WebAdministration module is loaded
if ((Get-Module "WebAdministration" -ErrorAction SilentlyContinue) -eq $null){
  Import-Module WebAdministration
}

$existing_http_redirect = @{
  enabled = (get-webconfigurationproperty -filter /system.webserver/httpRedirect -PSPath "$sitename" -name enabled).value
  child_only = (get-webconfigurationproperty -filter /system.webserver/httpRedirect -PSPath "$sitename" -name childonly).value
  exact_destination = (get-webconfigurationproperty -filter /system.webserver/httpRedirect -PSPath "$sitename" -name exactDestination).value
  destination = (get-webconfigurationproperty -filter /system.webserver/httpRedirect -PSPath "$sitename" -name Destination).value
  http_response_status = (get-webconfigurationproperty -filter /system.webserver/httpRedirect -PSPath "$sitename" -name httpResponseStatus)
  };

# Result
$result = @{
  changed = $false
  current = $existing_http_redirect
  added= @()
};

try {
  foreach ($item in $http_redirect.GetEnumerator())
  {
      if ($http_redirect.$($item.name) -ne $existing_http_redirect.$($item.name))
      {
          $mismatch = $true
          break;
      }
  }
  if ($mismatch) {
    Set-WebConfiguration `
    system.webServer/httpRedirect $sitename -Value @{ `
    enabled=$http_redirect.enabled; `
    destination=$http_redirect.destination; `
    childOnly=$http_redirect.child_only; `
    exactDestination=$http_redirect.exact_destination; `
    httpResponseStatus=$http_redirect.http_response_status}

    $result.added = $http_redirect
    $result.changed = $true
  }
}
catch {
  Fail-Json $result $_.Exception.Message
}

Exit-Json $result
