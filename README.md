# Services Portal
Information and sample code to assist third party developers when building mobile apps that use the ACRIS Airport Services API Portal

## Description: 
This respository contains Apple Xcode project artifacts (Swift), which illustrate basic use of information from the ACI-World ACRIS Airport Services Portal. 

NOTE: The sample project is a template for third parties developing applications wanting to advertise the use of an airport security checkpoint virtual queuing implementation. The data inlcudes airport related information and several URLs to simplify access to an airport's virtual queuing solution.

![Xcode](https://img.shields.io/badge/Xcode-007ACC?style=for-the-badge&logo=Xcode&logoColor=white)
![Swift](https://img.shields.io/badge/swift-F54A2A?style=for-the-badge&logo=swift&logoColor=white)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Table of Contents
* [General Info](#general-information)
* [Technologies Used](#technologies-used)
* [Features](#features)
* [Screenshots](#screenshots)
* [Architecture](#architecture)
* [Setup](#setup)
* [Usage](#usage)
* [Project Status](#project-status)
* [Room for Improvement](#room-for-improvement)
* [Acknowledgements](#acknowledgements)
* [Contact](#contact)
<!-- * [License](#license) -->
## General Information
- Provide general information about your project here.
  - Sample code used to access an industry standard RESTful API.  
- What problem does it (intend to) solve?
  - Code snipits can be used to accelerate development of mobile applications.
- What is the purpose of your project?
  - The goal was to help developers build mobile apps faster by reducing their learning curve.
- Why did you undertake it?
  - ACRIS is an important informaiton sharing resource for the airport industry.
<!-- You don't have to answer all the questions - just the ones relevant to your project. -->
## Technologies Used
- Xcode=13.4
- Swift=5.5
- IOS=15.5
- ACRIS-AGIM-Concessions-and-Seamless-Travel=2.0
## Features
List the ready features here:
- Illustrates four RESTfull interfaces
  - airportservices/v2/airports/servicecategories/
  - airportservices/v2/airports/services/servicecategories/{service_category_id}/
  - airportservices/v2/airports/{airport_code}/services/servicecategories/{service_category_id}/
  - airportservices/v2/references/airports/{iata_code}/queues/
- Contains examples of conversion from JSON raw data to Swift useable data structures
- Very simple IOS application
## Screenshots
![Example screenshot](./ScreenShot.jpg)
<!-- If you have screenshots you'd like to share, include them here. -->
## Architecture
![Example screenshot](./ArchDiagram.jpg)
<!-- If you have screenshots you'd like to share, include them here. -->
## Setup
What are the project requirements/dependencies? Where are they listed? A requirements.txt or a Pipfile.lock file perhaps? Where is it located?
- git clone the publi repository 
```
git clone https://github.com/parttimehacker/services_portal.git
```
## Usage
I recommend extracting code segments from the repository to prototype future mobile applications. The most important code examples are the interface classes that extract JSON data from the ACRIS API.
- NetworkSingleton.swift
- ServiceCategoriesSingleton.swift
- ServiceOfferingSingleton.swift
## Implementation Status
![Status](https://progress-bar.dev/60/?title=progress)
## Room for Improvement
Include areas you believe need improvement / could be improved. Also add TODOs for future development.
- Further refactoring to more generalize the application
- Test the downloading and cloning of the repository to see if it works correctly?!?
## Acknowledgements
Give credit here.
- The ACRIS Team!!!
- Many thanks to... Humphrey and Bob!!!
## Contact
Created by [@parttimehacker](http://parttimehacker.io/) - feel free to contact me!
### Repository Stats
![Your Repository’s Stats](https://github-readme-stats.vercel.app/api?username=parttimehacker&show_icons=true)
### Repository Languages
![Your Repository's Stats](https://github-readme-stats.vercel.app/api/top-langs/?username=parttimehacker&theme=blue-green)
### HITS
![Hits](https://hitcounter.pythonanywhere.com/count/tag.svg?url=https://github.com/parttimehacker)
<!-- Optional -->
<!-- ## License -->
<!-- This project is open source and available under the [... License](). -->

<!-- You don't have to include all sections - just the one's relevant to your project -->
