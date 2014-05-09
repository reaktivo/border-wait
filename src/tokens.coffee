# Constants
module.exports =
  type:
    passenger: 'passenger_vehicle_lanes'
    pedestrian: 'pedestrian_lanes'
    commercial: 'commercial_vehicle_lanes'
  lane:
    standard: 'standard_lanes'
    sentri: 'NEXUS_SENTRI_lanes'
    readylane: 'ready_lanes'
    fast: 'FAST_lanes'
  delay: /(\d+ hrs?)?\s?(\d+(?: min)?)?/i