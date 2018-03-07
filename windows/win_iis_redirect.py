#!/usr/bin/python
# -*- coding: utf-8 -*-

# (c) 2018, Kyle Briggs <briggsy87@gmail.com>
#
# This file is part of Ansible
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

# this is a windows documentation stub.  actual code lives in the .ps1
# file of the same name

DOCUMENTATION = '''
---
module: win_iis_redirect
version_added: ""
short_description: Create an HTTP redirect in IIS
description:
     - Uses Powershell commandlets.  Checks the current values of the HTTP redirect for the specified site, if any of the values supplied to not match the current values, the command is run to set the redirect to the specified values.
options:
  site_name:
    description:
      - The name of the IIS site
    required: false
    default: IIS:\sites\Default Web Site
    aliases: []
  enabled:
    description:
      - Whether the http redirect is enable or not.
    required: false
    choices:
      - true
      - false
    default: true
    aliases: []
  child_only:
    description:
      - Whether this redirect should effect child only. More info found here: https://docs.microsoft.com/en-us/iis/configuration/system.webserver/httpredirect/#attributes
    required: false
    choices:
      - true
      - false
    default: false
    aliases: []
  exact_destination:
    description:
      - Whether this redirect should apply to the exact location. More info found here: https://docs.microsoft.com/en-us/iis/configuration/system.webserver/httpredirect/#attributes
    required: false
    choices:
      - true
      - false
    default: false
    aliases: []
  destination:
    description:
      - The URL this should direct to
    required: yes
    default: null
    aliases: []
  http_response_status:
    description:
      - Specifies the type of redirection. More info found here: https://docs.microsoft.com/en-us/iis/configuration/system.webserver/httpredirect/#attributes
    required: false
    choices:
      - Found
      - Permanent
      - Temporary
      - Permanent Redirect
    default: Found
    aliases: []

author: Kyle Briggs
'''

EXAMPLES = '''
# Playbook example
---
- name : IIS redirect
  win_iis_redirect:
    site_name: IIS:\sites\My Website
    enabled: true
    child_only: true
    exact_destination: false
    destination: https://mywebsite.com/
    http_response_status: Permanent
'''