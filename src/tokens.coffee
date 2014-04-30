# Constants
module.exports =
  type:
    passenger: 'passenger_vehicle_lanes'
    pedestrian: 'pedestrian_lanes'
    commercial: 'commercial_vehicle_lanes'
  lane:
    standard: 'standard_lanes'
    sentri: 'ready_lanes'
    readylane: 'NEXUS_SENTRI_lanes'
    fast: 'FAST_lanes'
  delay: /(\d+ hrs?)?\s?(\d+(?: min)?)?/i