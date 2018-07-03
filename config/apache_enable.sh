#!/bin/bash

cd /etc/apache2/sites-available
a2ensite *
cd /
service apache2 reload