#!/bin/bash


j2 core-site.xml.j2 > /spark/conf/core-site.xml 

# Hand off to the CMD
exec "$@"
