================================================================================
CiconiaGIS WebGIS Application
MSc Research: Spatial Decision Support System & Habitat Suitability for Storks
================================================================================

Target DS Divisions: Bingiriya (BG), Chilaw (CH), Kuliyapitiya West (KW), Paduwasnuwara West (PW)
Ecological Strata: 
  - TCRW: Tank-Cascade & Riparian Wetlands
  - WPAE: Wet-Paddy Agro-Ecosystems

Files in this Directory:
  1. CiconiaGIS_Stork_Connectivity_MCE_WebGIS.html : Main Standalone WebGIS application.
  2. index.html                                   : Web Application entry point (mirrors main file).
  3. CiconiaGIS_phpMyAdmin_Relational_Schema.sql  : 9-Table MySQL/MariaDB database schema.
  4. chilaw_geoboundary.geojson                  : Official boundary polygon for Chilaw DS division.
  5. chilaw_20_quantum_points.json               : Quantum VQE optimized candidate points for Chilaw.
  6. CiconiaGIS_Logo.jpg                         : Project emblem & header icon.

How to Run:
  A. Standalone Offline / Browser:
     Double-click 'CiconiaGIS_Stork_Connectivity_MCE_WebGIS.html' or 'index.html' to open in Chrome/Edge/Firefox.
     Full features (Leaflet Maps, Google Maps, Point Cards, In-situ MCE survey, QA Suite) operate offline.

  B. Localhost Server (XAMPP):
     All files are also deployed to: C:\xampp\htdocs\CiconiaGIS\
     Start Apache in XAMPP and visit: http://localhost/CiconiaGIS/index.html
