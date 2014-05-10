# tokens.coffee.md

This file is used to store tokens used by the parser
to extract the parts of the xml file that we are
interested in.

    module.exports =

      type:
        passenger: 'passenger_vehicle_lanes'
        pedestrian: 'pedestrian_lanes'
        commercial: 'commercial_vehicle_lanes'

I found that the xml file with border wait times that
we extract from the CBP doesn't follow any set of rules,
sometimes mixing lowercase and camelcase style strings
when defining line types.

      lane:
        standard: 'standard_lanes'
        sentri: 'NEXUS_SENTRI_lanes'
        readylane: 'ready_lanes'
        fast: 'FAST_lanes'

I also include a small but hellish regular expression
to extract delay information for a port lane. It seems
that the CBP doesn't follow any set of rules, but this
regexp seems to do handle all cases, at least for now.

      delay: /(\d+ hrs?)?\s?(\d+(?: min)?)?/i