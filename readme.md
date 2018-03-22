ansible-modules
====================

This is just a personal collection of some Ansible modules I have written

Current modules:
- Windows
  - `win_iis_redirect`
    - setup http redirect in IIS website

To use these in your playbooks:
Navigate to your playbooks root directory and create a library folder if one doesn't already exist, then clone this repository:

```
	mkdir library && cd library
	git clone https://github.com/briggsy87/ansible-modules.git
```

Once that is done, provided the files are now in the library folder, Ansible can access these modules. Usage information can be found in the modules themselves.

