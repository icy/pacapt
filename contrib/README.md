
First, install all the dependencies

For Fedora:
````
# dnf install @development-tools
# dnf install fedora-packager
# dnf install rpmdevtools
````
For CentOS, RHEL:
````
# yum install rpm-build
````
For OpenSuSE, refer to the OpenSuSE wiki (https://en.opensuse.org/SDB:Compiling_software#Prerequisites).

Now, if you haven't created the rpmbuild directory in your home yet, you can do this using this command:
````
$ cd $HOME
$ rpmdev-setuptree
````
Ok, now we're set up for compiling, now just download the latest release of pacapt (you can find it on the github page, go on Releases), download it in .tar.gz format:
````
$ cd $HOME/rpmbuild/SOURCES
$ wget https://github.com/icy/pacapt/archive/v2.3.15.tar.gz
$ mv v2.3.15.tar.gz pacapt-2.3.15.tar.gz
````
And now download the spec file in this contrib directory and place it in ````$HOME/rpmbuild/SPECS````

Then, compile it:
````
$ rpmbuild -ba $HOME/rpmbuild/SPECS/pacapt.spec
````
And you're done! Your generated RPM will be in ````$HOME/rpmbuild/RPMS/noarch>/````
