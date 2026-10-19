-- ============================================================================
-- CiconiaGIS Relational Spatial & AHP-MCE Field Observation Database Schema
-- Database Name: CiconiaGIS (MySQL / MariaDB - phpMyAdmin Compatible)
-- MSc Research: GIS-Based Multi-Criteria Evaluation of Habitat Suitability
--               for Storks (Ciconiidae) Under Anthropogenic Pressure Across
--               Selected Agro-Wetland Landscapes in Bingiriya, Chilaw,
--               Kuliyapitiya West, and Paduwasnuwara West DS Divisions,
--               North Western Province, Sri Lanka
-- ============================================================================

CREATE DATABASE IF NOT EXISTS `CiconiaGIS` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `CiconiaGIS`;

SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------------------------------------------------------
-- TABLE 1: ds_divisions (Divisional Secretariat Master Reference Table)
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS `ds_divisions`;
CREATE TABLE `ds_divisions` (
  `ds_code` VARCHAR(5) NOT NULL COMMENT 'Primary Key: BG, CH, KW, PW',
  `ds_name` VARCHAR(100) NOT NULL COMMENT 'Divisional Secretariat Name',
  `auto_label_prefix` VARCHAR(10) NOT NULL COMMENT 'Mandatory Prefix: BG/, CH/, KW/, PW/',
  `boundary_color_hex` VARCHAR(10) NOT NULL COMMENT 'GIS Boundary Polygon Stroke Color',
  `centroid_lat_y` DECIMAL(10,6) NOT NULL COMMENT 'DS Division Centroid Latitude Y (WGS84)',
  `centroid_lon_x` DECIMAL(10,6) NOT NULL COMMENT 'DS Division Centroid Longitude X (WGS84)',
  PRIMARY KEY (`ds_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `ds_divisions` (`ds_code`, `ds_name`, `auto_label_prefix`, `boundary_color_hex`, `centroid_lat_y`, `centroid_lon_x`) VALUES
('BG', 'Bingiriya', 'BG/', '#059669', 7.618500, 79.952200),
('CH', 'Chilaw', 'CH/', '#2563eb', 7.575800, 79.795300),
('KW', 'Kuliyapitiya West', 'KW/', '#d97706', 7.479500, 80.039100),
('PW', 'Paduwasnuwara West', 'PW/', '#7c3aed', 7.602400, 80.048500);

-- ----------------------------------------------------------------------------
-- TABLE 2: habitat_types (Ecological Habitat Strata Master Table)
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS `habitat_types`;
CREATE TABLE `habitat_types` (
  `habitat_code` VARCHAR(10) NOT NULL COMMENT 'Primary Key: TCRW, WPAE',
  `habitat_type_name` VARCHAR(120) NOT NULL COMMENT 'Ecological Habitat Type / Land-Use Category',
  `default_microhabitat_guild` VARCHAR(120) NOT NULL COMMENT 'Default Dominant Microhabitat Guild Description',
  `map_color_hex` VARCHAR(10) NOT NULL,
  `ecological_description` TEXT NULL,
  PRIMARY KEY (`habitat_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `habitat_types` (`habitat_code`, `habitat_type_name`, `default_microhabitat_guild`, `map_color_hex`, `ecological_description`) VALUES
('TCRW', 'Tank-Cascade and Riparian Wetland Systems', 'MH1 (Tank Cascade Spill, Macrophyte Margin & Riparian Kumbuk Fringe)', '#0284c7', 'Inland small-to-medium village tank cascades, spill canals, interconnected stream networks, and riparian fringe vegetation.'),
('WPAE', 'Wet-Paddy Agro-Ecosystems', 'MH2 (Inundated Wet-Paddy, Mudflat & Drainage Furrow)', '#16a34a', 'Inundated low-country wet-paddy fields, irrigation field channels, mud flats, and fallow wetland patches.');

-- ----------------------------------------------------------------------------
-- TABLE 3: sampling_points (Spatial Candidate Points Optimized via PennyLane VQE)
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS `sampling_points`;
CREATE TABLE `sampling_points` (
  `point_id` VARCHAR(16) NOT NULL COMMENT 'Primary Key: ORIG-001, NEW-081...',
  `full_label` VARCHAR(30) NOT NULL COMMENT 'Formatted Label: BG/TCRW/01...',
  `seq_num` INT NOT NULL,
  `name` VARCHAR(180) NOT NULL,
  `ds_code` VARCHAR(5) NOT NULL,
  `habitat_code` VARCHAR(10) NOT NULL,
  `lat` DECIMAL(10,6) NOT NULL,
  `lon` DECIMAL(10,6) NOT NULL,
  `z_dem` DECIMAL(6,2) NOT NULL,
  `z_source` VARCHAR(50) DEFAULT 'SRTM DEM 30m',
  `point_source` VARCHAR(20) DEFAULT 'Original',
  `road_access_m` DECIMAL(6,1) DEFAULT NULL,
  `q_score` DECIMAL(5,3) DEFAULT NULL,
  `quantum_algorithm` VARCHAR(100) DEFAULT 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)',
  `ground_state_energy` DECIMAL(7,4) DEFAULT NULL,
  PRIMARY KEY (`point_id`),
  UNIQUE KEY `idx_full_label` (`full_label`),
  KEY `fk_pt_ds` (`ds_code`),
  KEY `fk_pt_hab` (`habitat_code`),
  CONSTRAINT `fk_pt_ds` FOREIGN KEY (`ds_code`) REFERENCES `ds_divisions` (`ds_code`) ON UPDATE CASCADE,
  CONSTRAINT `fk_pt_hab` FOREIGN KEY (`habitat_code`) REFERENCES `habitat_types` (`habitat_code`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `sampling_points` (`point_id`, `full_label`, `seq_num`, `name`, `ds_code`, `habitat_code`, `lat`, `lon`, `z_dem`, `z_source`, `point_source`, `road_access_m`, `q_score`, `quantum_algorithm`, `ground_state_energy`) VALUES
('ORIG-001', 'BG/TCRW/01', 1, 'Weerakodiyana Tank & Inflow Wetland', 'BG', 'TCRW', 7.618450, 79.932150, 18.50, 'SRTM DEM 30m', 'Original', 35, 0.923, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0737),
('ORIG-002', 'BG/TCRW/02', 2, 'Deduru Oya Riverine Kumbuk Forest Margin', 'BG', 'TCRW', 7.631240, 79.918450, 14.20, 'SRTM DEM 30m', 'Original', 45, 0.923, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0679),
('ORIG-003', 'BG/TCRW/03', 3, 'Kavudumunna Tank Cascades & Littoral Bed', 'BG', 'TCRW', 7.604120, 79.945210, 21.00, 'SRTM DEM 30m', 'Original', 30, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0745),
('ORIG-004', 'BG/TCRW/04', 4, 'Ihala Kadigamuwa Ancient Wewa Margin', 'BG', 'TCRW', 7.589450, 79.962140, 23.40, 'SRTM DEM 30m', 'Original', 40, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0743),
('ORIG-005', 'BG/TCRW/05', 5, 'Kolambalamuna Riverine Stream Confluence', 'BG', 'TCRW', 7.625120, 79.951230, 17.80, 'SRTM DEM 30m', 'Original', 50, 0.923, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0729),
('ORIG-006', 'BG/TCRW/06', 6, 'Bingiriya Central Cascade Wewa Outflow', 'BG', 'TCRW', 7.578450, 79.924150, 16.50, 'SRTM DEM 30m', 'Original', 25, 0.923, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0721),
('ORIG-007', 'BG/TCRW/07', 7, 'Pahala Kadigamuwa Riparian Wetland Strip', 'BG', 'TCRW', 7.592140, 79.975420, 24.10, 'SRTM DEM 30m', 'Original', 35, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0786),
('ORIG-008', 'BG/TCRW/08', 8, 'Thalwita Tank Reed Bed & Stork Foraging Site', 'BG', 'TCRW', 7.638450, 79.965410, 20.30, 'SRTM DEM 30m', 'Original', 45, 0.923, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0730),
('ORIG-009', 'BG/TCRW/09', 9, 'Madampe-Bingiriya Border Stream Wetland', 'BG', 'TCRW', 7.568410, 79.908450, 13.20, 'SRTM DEM 30m', 'Original', 60, 0.923, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0681),
('ORIG-010', 'BG/TCRW/10', 10, 'Koswatta Riverine Roosting Canopy', 'BG', 'TCRW', 7.612150, 79.981240, 22.80, 'SRTM DEM 30m', 'Original', 30, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0803),
('ORIG-011', 'BG/WPAE/01', 11, 'Bingiriya Broad Agro-Ecosystem Paddy Tract', 'BG', 'WPAE', 7.613905, 79.953739, 19.40, 'SRTM DEM 30m', 'Original', 25, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0820),
('ORIG-012', 'BG/WPAE/02', 12, 'Weerakodiyana Lowland Muddy Paddy Fields', 'BG', 'WPAE', 7.615240, 79.925410, 17.10, 'SRTM DEM 30m', 'Original', 30, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0782),
('ORIG-013', 'BG/WPAE/03', 13, 'Kavudumunna Inundated Wet-Paddy Basin', 'BG', 'WPAE', 7.601240, 79.938740, 19.80, 'SRTM DEM 30m', 'Original', 20, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0835),
('ORIG-014', 'BG/WPAE/04', 14, 'Kadigamuwa Terraced Agro-Ecosystem Tract', 'BG', 'WPAE', 7.585410, 79.968450, 22.50, 'SRTM DEM 30m', 'Original', 35, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0843),
('ORIG-015', 'BG/WPAE/05', 15, 'Kolambalamuna Drainage Wet-Paddy Strip', 'BG', 'WPAE', 7.621450, 79.942150, 16.90, 'SRTM DEM 30m', 'Original', 40, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0772),
('ORIG-016', 'BG/WPAE/06', 16, 'Thalwita Lowland Paddy Agro-Ecosystem', 'BG', 'WPAE', 7.632140, 79.958740, 19.50, 'SRTM DEM 30m', 'Original', 30, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0821),
('ORIG-017', 'BG/WPAE/07', 17, 'Bingiriya South Mudflat Paddy Corridor', 'BG', 'WPAE', 7.574120, 79.931250, 17.40, 'SRTM DEM 30m', 'Original', 25, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0790),
('ORIG-018', 'BG/WPAE/08', 18, 'Ihala Kadigamuwa Snail Foraging Paddy', 'BG', 'WPAE', 7.595420, 79.955410, 21.20, 'SRTM DEM 30m', 'Original', 20, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0863),
('ORIG-019', 'BG/WPAE/09', 19, 'Western Border Wet-Paddy Agricultural Mosaic', 'BG', 'WPAE', 7.571290, 79.905661, 14.80, 'SRTM DEM 30m', 'Original', 45, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0759),
('ORIG-020', 'BG/WPAE/10', 20, 'Deduru Oya Valley Wet-Paddy Tract', 'BG', 'WPAE', 7.628410, 79.928450, 15.60, 'SRTM DEM 30m', 'Original', 35, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0791),
('ORIG-021', 'CH/TCRW/01', 21, 'Deduru Oya River Mouth & Estuarine Mudflat', 'CH', 'TCRW', 7.611420, 79.794850, 2.10, 'SRTM DEM 30m', 'Original', 45, 0.922, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0508),
('ORIG-022', 'CH/TCRW/02', 22, 'Deduru Oya Lower Riverine Kumbuk Forest Corridor', 'CH', 'TCRW', 7.608310, 79.805210, 3.40, 'SRTM DEM 30m', 'Original', 35, 0.923, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0580),
('ORIG-023', 'CH/TCRW/03', 23, 'Chilaw Lagoon Northern Mangrove Fringe & Shoreline', 'CH', 'TCRW', 7.589140, 79.792340, 1.80, 'SRTM DEM 30m', 'Original', 55, 0.922, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0429),
('ORIG-024', 'CH/TCRW/04', 24, 'Munneswaram Holy Tank Littoral Shallow Margin', 'CH', 'TCRW', 7.576820, 79.817450, 6.80, 'SRTM DEM 30m', 'Original', 25, 0.923, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0610),
('ORIG-025', 'CH/TCRW/05', 25, 'Ambakandawila Backwater Lagoon & Mudflat Basin', 'CH', 'TCRW', 7.551240, 79.802110, 2.50, 'SRTM DEM 30m', 'Original', 40, 0.922, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0519),
('ORIG-026', 'CH/TCRW/06', 26, 'Deduru Oya Old Meander Oxbow Wetland', 'CH', 'TCRW', 7.614850, 79.822340, 4.10, 'SRTM DEM 30m', 'Original', 50, 0.923, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0622),
('ORIG-027', 'CH/TCRW/07', 27, 'Pambala Mangrove Sanctuary & Tidal Creek', 'CH', 'TCRW', 7.530120, 79.808750, 2.20, 'SRTM DEM 30m', 'Original', 65, 0.922, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0499),
('ORIG-028', 'CH/TCRW/08', 28, 'Kakkapalliya Tank Inundation Margin & Reed Bed', 'CH', 'TCRW', 7.535890, 79.834150, 8.20, 'SRTM DEM 30m', 'Original', 20, 0.923, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0642),
('ORIG-029', 'CH/TCRW/09', 29, 'Waikkala-Chilaw Canal Riparian Roosting Corridor', 'CH', 'TCRW', 7.518450, 79.824150, 4.50, 'SRTM DEM 30m', 'Original', 45, 0.923, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0598),
('ORIG-030', 'CH/TCRW/10', 30, 'Toduwawa Estuarine Wetland & Coastal Lagoon Margin', 'CH', 'TCRW', 7.509820, 79.811450, 1.90, 'SRTM DEM 30m', 'Original', 50, 0.922, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0453),
('ORIG-031', 'CH/WPAE/01', 31, 'Karukkuwa Agro-Wetland Basin & Flooded Fields', 'CH', 'WPAE', 7.564120, 79.829150, 5.20, 'SRTM DEM 30m', 'Original', 30, 0.923, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0664),
('ORIG-032', 'CH/WPAE/02', 32, 'Manuwangamuwa Wet-Paddy Agro-Ecosystem Tract', 'CH', 'WPAE', 7.598210, 79.835420, 7.50, 'SRTM DEM 30m', 'Original', 35, 0.923, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0719),
('ORIG-033', 'CH/WPAE/03', 33, 'Chilaw - Bingiriya Agrarian Transition Paddy Zone', 'CH', 'WPAE', 7.582450, 79.871240, 11.40, 'SRTM DEM 30m', 'Original', 40, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0800),
('ORIG-034', 'CH/WPAE/04', 34, 'Sawana Agricultural Lowland Drainage Paddy Basin', 'CH', 'WPAE', 7.558740, 79.851230, 6.30, 'SRTM DEM 30m', 'Original', 30, 0.923, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0686),
('ORIG-035', 'CH/WPAE/05', 35, 'Arachchikattuwa Border Floodplain Paddy Field', 'CH', 'WPAE', 7.618950, 79.862140, 9.80, 'SRTM DEM 30m', 'Original', 40, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0779),
('ORIG-036', 'CH/WPAE/06', 36, 'Karukkuwa East Inundated Paddy Flight Corridor', 'CH', 'WPAE', 7.562150, 79.865420, 8.50, 'SRTM DEM 30m', 'Original', 35, 0.923, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0732),
('ORIG-037', 'CH/WPAE/07', 37, 'Merawala Wet-Paddy Foraging Lowland Tract', 'CH', 'WPAE', 7.545120, 79.822140, 4.20, 'SRTM DEM 30m', 'Original', 30, 0.923, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0639),
('ORIG-038', 'CH/WPAE/08', 38, 'Koralawella Agricultural Snail Foraging Paddy', 'CH', 'WPAE', 7.569450, 79.845120, 6.10, 'SRTM DEM 30m', 'Original', 25, 0.923, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0696),
('ORIG-039', 'CH/WPAE/09', 39, 'Wilpotha Low-lying Paddy Agro-Ecosystem Basin', 'CH', 'WPAE', 7.621450, 79.851230, 9.10, 'SRTM DEM 30m', 'Original', 35, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0768),
('ORIG-040', 'CH/WPAE/10', 40, 'Deduru Oya South Flooded Agro-Wetland Field', 'CH', 'WPAE', 7.604150, 79.818450, 3.80, 'SRTM DEM 30m', 'Original', 40, 0.923, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0620),
('ORIG-041', 'KW/TCRW/01', 41, 'Dandagamuwa Ancient Tank Cascade Littoral Margin', 'KW', 'TCRW', 7.481240, 80.038450, 32.10, 'SRTM DEM 30m', 'Original', 25, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0783),
('ORIG-042', 'KW/TCRW/02', 42, 'Kolamunu Oya Riverine Stream & Riparian Belt', 'KW', 'TCRW', 7.495420, 80.021450, 26.50, 'SRTM DEM 30m', 'Original', 40, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0823),
('ORIG-043', 'KW/TCRW/03', 43, 'Meewellawa Wewa Waterbody Margin & Reed Bed', 'KW', 'TCRW', 7.512450, 80.045120, 35.00, 'SRTM DEM 30m', 'Original', 30, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0776),
('ORIG-044', 'KW/TCRW/04', 44, 'Kithalawa Tank Inundation Margin & Roosting Kumbuk', 'KW', 'TCRW', 7.468450, 80.058450, 31.40, 'SRTM DEM 30m', 'Original', 35, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0808),
('ORIG-045', 'KW/TCRW/05', 45, 'Kuliyapitiya Stream Outflow Cascade Wetland', 'KW', 'TCRW', 7.472670, 80.054680, 29.80, 'SRTM DEM 30m', 'Original', 20, 0.923, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0723),
('ORIG-046', 'KW/TCRW/06', 46, 'Bohandiya Tank Cascade Littoral Fringe', 'KW', 'TCRW', 7.524150, 80.031240, 33.20, 'SRTM DEM 30m', 'Original', 35, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0797),
('ORIG-047', 'KW/TCRW/07', 47, 'Ihala Kalugamuwa Wetland Tank Buffer', 'KW', 'TCRW', 7.458450, 80.071240, 34.50, 'SRTM DEM 30m', 'Original', 45, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0752),
('ORIG-048', 'KW/TCRW/08', 48, 'Nakalagamuwa Riparian Stream Confluence', 'KW', 'TCRW', 7.504120, 80.062150, 30.10, 'SRTM DEM 30m', 'Original', 50, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0812),
('ORIG-049', 'KW/TCRW/09', 49, 'Kadurugahawatta Tank Cascade Marsh', 'KW', 'TCRW', 7.489150, 80.081240, 33.80, 'SRTM DEM 30m', 'Original', 30, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0771),
('ORIG-050', 'KW/TCRW/10', 50, 'Diwullegoda Village Tank Roosting Trees', 'KW', 'TCRW', 7.538191, 80.016298, 28.40, 'SRTM DEM 30m', 'Original', 25, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0798),
('ORIG-051', 'KW/WPAE/01', 51, 'Dandagamuwa Extensive Wet-Paddy Agro-Ecosystem', 'KW', 'WPAE', 7.478450, 80.042150, 30.80, 'SRTM DEM 30m', 'Original', 20, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0935),
('ORIG-052', 'KW/WPAE/02', 52, 'Meewellawa Terraced Wet-Paddy Agricultural Basin', 'KW', 'WPAE', 7.508450, 80.048750, 33.50, 'SRTM DEM 30m', 'Original', 25, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0929),
('ORIG-053', 'KW/WPAE/03', 53, 'Kolamunu Oya Valley Lowland Muddy Paddy Fields', 'KW', 'WPAE', 7.491240, 80.028450, 27.20, 'SRTM DEM 30m', 'Original', 35, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0920),
('ORIG-054', 'KW/WPAE/04', 54, 'Kithalawa Agro-Wetland Wet-Paddy Tract', 'KW', 'WPAE', 7.464120, 80.062140, 32.00, 'SRTM DEM 30m', 'Original', 30, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0903),
('ORIG-055', 'KW/WPAE/05', 55, 'Bohandiya Inundated Wet-Paddy Corridor', 'KW', 'WPAE', 7.521450, 79.998450, 27.50, 'SRTM DEM 30m', 'Original', 30, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0883),
('ORIG-056', 'KW/WPAE/06', 56, 'Ihala Kalugamuwa Agricultural Wet-Paddy Plain', 'KW', 'WPAE', 7.452140, 80.078450, 35.10, 'SRTM DEM 30m', 'Original', 40, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0900),
('ORIG-057', 'KW/WPAE/07', 57, 'Nakalagamuwa Broad Lowland Paddy Mosaic', 'KW', 'WPAE', 7.498450, 80.068750, 31.20, 'SRTM DEM 30m', 'Original', 25, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0912),
('ORIG-058', 'KW/WPAE/08', 58, 'Kadurugahawatta Wet-Paddy Snail Foraging Area', 'KW', 'WPAE', 7.485861, 80.135362, 34.20, 'SRTM DEM 30m', 'Original', 35, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0907),
('ORIG-059', 'KW/WPAE/09', 59, 'Diwullegoda Muddy Paddy Inundation Basin', 'KW', 'WPAE', 7.534120, 80.022140, 29.00, 'SRTM DEM 30m', 'Original', 20, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0918),
('ORIG-060', 'KW/WPAE/10', 60, 'Kuliyapitiya North Agrarian Lowland Field', 'KW', 'WPAE', 7.482150, 80.051240, 30.40, 'SRTM DEM 30m', 'Original', 25, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0885),
('ORIG-061', 'PW/TCRW/01', 61, 'Panduwasnuwara Ancient Royal Wewa Littoral Margin', 'PW', 'TCRW', 7.621450, 80.065420, 28.50, 'SRTM DEM 30m', 'Original', 25, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0793),
('ORIG-062', 'PW/TCRW/02', 62, 'Koon Wewa Tank Cascade & Snail Foraging Bed', 'PW', 'TCRW', 7.637458, 80.095747, 31.20, 'SRTM DEM 30m', 'Original', 30, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0778),
('ORIG-063', 'PW/TCRW/03', 63, 'Kolamunu Oya Upper Riparian Riverine Corridor', 'PW', 'TCRW', 7.608450, 80.048750, 25.10, 'SRTM DEM 30m', 'Original', 45, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0812),
('ORIG-064', 'PW/TCRW/04', 64, 'Hettipola Border Stream & Riparian Roosting Forest', 'PW', 'TCRW', 7.584120, 80.092140, 32.40, 'SRTM DEM 30m', 'Original', 35, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0850),
('ORIG-065', 'PW/TCRW/05', 65, 'Kottamba Wewa Tank Outflow Marsh & Wading Site', 'PW', 'TCRW', 7.645120, 80.074510, 29.80, 'SRTM DEM 30m', 'Original', 40, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0762),
('ORIG-066', 'PW/TCRW/06', 66, 'Mahagalgamuwa Tank Cascades System', 'PW', 'TCRW', 7.615240, 80.081240, 30.50, 'SRTM DEM 30m', 'Original', 30, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0783),
('ORIG-067', 'PW/TCRW/07', 67, 'Kobeigane-Paduwasnuwara Stream Basin', 'PW', 'TCRW', 7.651240, 80.088450, 33.10, 'SRTM DEM 30m', 'Original', 50, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0849),
('ORIG-068', 'PW/TCRW/08', 68, 'Paduwasnuwara West Central Village Wewa', 'PW', 'TCRW', 7.593320, 80.085520, 29.20, 'SRTM DEM 30m', 'Original', 20, 0.923, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0735),
('ORIG-069', 'PW/TCRW/09', 69, 'Rambawila Inflow Stream & Reed Marsh', 'PW', 'TCRW', 7.628450, 80.052140, 26.80, 'SRTM DEM 30m', 'Original', 35, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0799),
('ORIG-070', 'PW/TCRW/10', 70, 'Ihala Wewa Riparian Buffer & Roosting Trees', 'PW', 'TCRW', 7.632150, 80.102140, 32.80, 'SRTM DEM 30m', 'Original', 40, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0870),
('ORIG-071', 'PW/WPAE/01', 71, 'Panduwasnuwara Broad Lowland Paddy Basin', 'PW', 'WPAE', 7.618450, 80.071240, 27.90, 'SRTM DEM 30m', 'Original', 20, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0903),
('ORIG-072', 'PW/WPAE/02', 72, 'Koon Wewa Inundated Muddy Paddy Fields', 'PW', 'WPAE', 7.632140, 80.091240, 30.40, 'SRTM DEM 30m', 'Original', 25, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0921),
('ORIG-073', 'PW/WPAE/03', 73, 'Kolamunu Oya Valley Wet-Paddy Agro-Ecosystem', 'PW', 'WPAE', 7.604120, 80.054120, 25.80, 'SRTM DEM 30m', 'Original', 30, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0882),
('ORIG-074', 'PW/WPAE/04', 74, 'Hettipola Low-lying Terraced Paddy Tract', 'PW', 'WPAE', 7.579450, 80.098450, 31.80, 'SRTM DEM 30m', 'Original', 35, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0903),
('ORIG-075', 'PW/WPAE/05', 75, 'Kottamba Wet-Paddy Basin Agro-Ecosystem', 'PW', 'WPAE', 7.641240, 80.078450, 29.10, 'SRTM DEM 30m', 'Original', 25, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0925),
('ORIG-076', 'PW/WPAE/06', 76, 'Mahagalgamuwa Flooded Paddy Foraging Grounds', 'PW', 'WPAE', 7.611250, 80.085420, 29.90, 'SRTM DEM 30m', 'Original', 20, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0901),
('ORIG-077', 'PW/WPAE/07', 77, 'Kobeigane Border Agro-Wetland Tract', 'PW', 'WPAE', 7.648120, 80.092140, 32.50, 'SRTM DEM 30m', 'Original', 30, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0897),
('ORIG-078', 'PW/WPAE/08', 78, 'Paduwasnuwara West Agrarian Corridor Field', 'PW', 'WPAE', 7.589140, 80.081240, 28.70, 'SRTM DEM 30m', 'Original', 25, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0877),
('ORIG-079', 'PW/WPAE/09', 79, 'Rambawila Lowland Drainage Paddy Strip', 'PW', 'WPAE', 7.625140, 80.058450, 27.20, 'SRTM DEM 30m', 'Original', 35, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0889),
('ORIG-080', 'PW/WPAE/10', 80, 'Koon Wewa East Inundated Paddy Agro-Ecosystem', 'PW', 'WPAE', 7.635410, 80.108450, 32.10, 'SRTM DEM 30m', 'Original', 30, 0.924, 'PennyLane 4-Qubit Variational Hamiltonian Optimizer (VQE)', 0.0903);

SET FOREIGN_KEY_CHECKS = 1;
