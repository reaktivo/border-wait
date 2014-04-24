# Constants
module.exports =
  type:
    vehicular: /Passenger Vehicles .+?: (.+?) Pedestrian/i
    pedestrian: /Pedestrian .+?: (.+)$/i
  lane:
    standard: /Standard Lanes: (.+? open)/i
    sentri: /Sentri Lanes: (.+? open)/i
    readylane: /Readylane: (.+? open)/i
  delay: /(?:PDT|EST|PST)(?: (no delay)| ([0-9]+) hrs?,?)?(?: ([0-9]+) min)?.*open/i