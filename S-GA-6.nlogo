extensions [gis]
globals [neib-boundary interchange-land GA-parent1 GA-parent2 GA-parent3 GA-parent4 GAVList GAIResult]

breed [communitys community]
breed [households household]

patches-own [land-status distocenter distometro land-suit max-households new-develop-land community-belong land-2013]
communitys-own [community-ID total-households cohension-value c-vacancy-houses community-suit avg-household-age avg-household-revenue]
;;household-age
households-own [household-id community-b-id household-time household-status household-saving
  household-age household-revenue] ;;household-status is immigrants or local

to initial

  clear-all
  reset-ticks
  set interchange-land 0
  load-patches
  load-communitys
  load-households
  community-update

  ;setup from RNetlogo
;  set s-metro item 0 GAVList
;  set s-center item 1 GAVList
;  set r1 item 2 GAVList
;  set r2 item 3 GAVList
;  set s-compact item 4 GAVList
;  set s-compat item 5 GAVList
;  set t1 item 6 GAVList
;  set t2 item 7 GAVList
;  set u1 item 8 GAVList
;  set u2 item 9 GAVList
;  set omiga1 item 10 GAVList
;  set omiga2 item 11 GAVList
;  set omiga3 item 12 GAVList
;  set omiga4 item 13 GAVList

end
to load-patches
  set GA-parent1 []
  set GA-parent2 []
  set GA-parent3 []
  set GA-parent4 []

  set neib-boundary gis:load-dataset "data/Neib2000.shp"
  gis:set-drawing-color black
  gis:draw neib-boundary 0.5

;  gis:apply-coverage neib-boundary "CID" community-belong
  let neib gis:load-dataset "data/neighbourhood.asc"
  gis:apply-raster neib community-belong

  let currentland gis:load-dataset "data/currentlanduse.asc"
  gis:apply-raster currentland land-status


;  let land2013 gis:load-dataset "data/residential2013.asc"
;  gis:apply-raster land2013 land-2013

  let max-households-dataset gis:load-dataset "data/maxhouseholds.asc"
  gis:apply-raster max-households-dataset max-households

;  let suitability-dataset gis:load-dataset "data/developable.asc"
;  gis:apply-raster suitability-dataset land-suit

  let disc gis:load-dataset "data/distocenter.asc"
  gis:apply-raster disc distocenter

  let dism gis:load-dataset "data/distometro.asc"
  gis:apply-raster dism distometro

  foreach sort patches[ask ?[
      set new-develop-land 0
      set max-households round (max-households / simul-ratio)
      ;;0 as developable land, 1 is residential, 2 is industrial, 3 is park, 4 is agriculture, 5 is road or river, 6 is commericial, 7 is public facility
      if land-status = 0 [set pcolor white]
      if land-status = 1 [set pcolor orange]
      if land-status = 2 [set pcolor red]
      if land-status = 3 [set pcolor green]
      if land-status = 4 [set pcolor green]
      if land-status = 5 [set pcolor grey]
      if land-status = 6 [
        set land-status 1
        set pcolor 123]
      if land-status = 7 [set pcolor 132]
      ]]
end

to load-communitys
  foreach gis:feature-list-of neib-boundary[
    let location gis:location-of gis:centroid-of ?
    let c-id gis:property-value ? "CID"
    let HS gis:property-value ? "HS"
    if not empty? location[
      ask patch (item 0 location) (item 1 location)[
        sprout-communitys 1[
          set shape "house"
          set color 34
          set size 5
          set community-ID c-id
          set total-households HS
          ]]]]
end

to load-households
  ask patches with [land-status = 1 and community-belong > 0][
      let community community-belong
      let total-land count patches with [land-status = 1 and community-belong = community]

      let com gis:find-one-feature neib-boundary "CID" (word community)
      let com-households gis:property-value com "Family1"
      let unit-households (com-households / total-land / simul-ratio)
;      ask communitys with [community-ID = community][
;        set unit-households round (community-BDHS / total-land / simul-ratio)] ;;to reduce run time divide by 10
      sprout-households unit-households[
        set shape "dot"
        set color black
        set size 1
        set community-b-id community
        set household-age 3 + abs(random 5) * 0.1 + 1
        ;;before 1987, life is more stable, people move to a place and will stay there for a while
        set household-time household-age - 3 ;;how long they lived in current house
        set household-status 1 ;;household: 0 means new settlers; 1 means settlers; 2 means want to move
        set household-revenue (random-normal 21976 2000)
        set household-saving household-revenue * Householdsave-rate * household-time]

      set com gis:find-one-feature neib-boundary "CID" (word community)
      set com-households gis:property-value com "Family2"
      set unit-households (com-households / total-land / simul-ratio)
;      ask communitys with [community-ID = community][
;        set unit-households round (community-BDHS / total-land / simul-ratio)] ;;to reduce run time divide by 10
      sprout-households unit-households[
        set shape "dot"
        set color black
        set size 1
        set community-b-id community
        set household-age 3 + abs(random 5) * 0.1 + 2
        ;;before 1987, life is more stable, people move to a place and will stay there for a while
        set household-time household-age - 3 ;;how long they lived in current house
        set household-status 1 ;;household: 0 means new settlers; 1 means settlers; 2 means want to move
        set household-revenue (random-normal 21976 2000)
        set household-saving household-revenue * Householdsave-rate * household-time]

      set com gis:find-one-feature neib-boundary "CID" (word community)
      set com-households gis:property-value com "Family3"
      set unit-households (com-households / total-land / simul-ratio)
;      ask communitys with [community-ID = community][
;        set unit-households round (community-BDHS / total-land / simul-ratio)] ;;to reduce run time divide by 10
      sprout-households unit-households[
        set shape "dot"
        set color black
        set size 1
        set community-b-id community
        set household-age 3 + abs(random 5) * 0.1 + 3
        ;;before 1987, life is more stable, people move to a place and will stay there for a while
        set household-time household-age - 3 ;;how long they lived in current house
        set household-status 1 ;;household: 0 means new settlers; 1 means settlers; 2 means want to move
        set household-revenue (random-normal 21976 2000)
        set household-saving household-revenue * Householdsave-rate * household-time]

      set com gis:find-one-feature neib-boundary "CID" (word community)
      set com-households gis:property-value com "Family4"
      set unit-households (com-households / total-land  / simul-ratio)
;      ask communitys with [community-ID = community][
;        set unit-households round (community-BDHS / total-land / simul-ratio)] ;;to reduce run time divide by 10
      sprout-households unit-households[
        set shape "dot"
        set color black
        set size 1
        set community-b-id community
        set household-age 3 + abs(random 5) * 0.1 + 4
        ;;before 1987, life is more stable, people move to a place and will stay there for a while
        set household-time household-age - 3 ;;how long they lived in current house
        set household-status 1 ;;household: 0 means new settlers; 1 means settlers; 2 means want to move
        set household-revenue (random-normal 21976 2000)
        set household-saving household-revenue * Householdsave-rate * household-time]

      set com gis:find-one-feature neib-boundary "CID" (word community)
      set com-households gis:property-value com "Family5"
      set unit-households (com-households / total-land / simul-ratio)
;      ask communitys with [community-ID = community][
;        set unit-households round (community-BDHS / total-land / simul-ratio)] ;;to reduce run time divide by 10
      sprout-households unit-households[
        set shape "dot"
        set color black
        set size 1
        set community-b-id community
        set household-age 3 + abs(random 5) * 0.1 + 5
        ;;before 1987, life is more stable, people move to a place and will stay there for a while
        set household-time household-age - 3 ;;how long they lived in current house
        set household-status 1 ;;household: 0 means new settlers; 1 means settlers; 2 means want to move
        set household-revenue (random-normal 21976 2000)
        set household-saving household-revenue * Householdsave-rate * household-time]

      set com gis:find-one-feature neib-boundary "CID" (word community)
      set com-households gis:property-value com "Family6"
      set unit-households (com-households / total-land  / simul-ratio)
;      ask communitys with [community-ID = community][
;        set unit-households round (community-BDHS / total-land / simul-ratio)] ;;to reduce run time divide by 10
      sprout-households unit-households[
        set shape "dot"
        set color black
        set size 1
        set community-b-id community
        set household-age 3 + abs(random 5) * 0.1 + 6
        ;;before 1987, life is more stable, people move to a place and will stay there for a while
        set household-time household-age - 3 ;;how long they lived in current house
        set household-status 1 ;;household: 0 means new settlers; 1 means settlers; 2 means want to move
        set household-revenue (random-normal 21976 2000)
        set household-saving household-revenue * Householdsave-rate * household-time]

      set com gis:find-one-feature neib-boundary "CID" (word community)
      set com-households gis:property-value com "Family7"
      set unit-households (com-households / total-land / simul-ratio)
;      ask communitys with [community-ID = community][
;        set unit-households round (community-BDHS / total-land / simul-ratio)] ;;to reduce run time divide by 10
      sprout-households unit-households[
        set shape "dot"
        set color black
        set size 1
        set community-b-id community
        set household-age 3 + abs(random 5) * 0.1 + 7
        ;;before 1987, life is more stable, people move to a place and will stay there for a while
        set household-time household-age - 3 ;;how long they lived in current house
        set household-status 1 ;;household: 0 means new settlers; 1 means settlers; 2 means want to move
        set household-revenue (random-normal 21976 2000)
        set household-saving household-revenue * Householdsave-rate * household-time]

      set com gis:find-one-feature neib-boundary "CID" (word community)
      set com-households gis:property-value com "Family8"
      set unit-households (com-households / total-land / simul-ratio)
;      ask communitys with [community-ID = community][
;        set unit-households round (community-BDHS / total-land / simul-ratio)] ;;to reduce run time divide by 10
      sprout-households unit-households[
        set shape "dot"
        set color black
        set size 1
        set community-b-id community
        set household-age 3 + abs(random 5) * 0.1 + 8
        ;;before 1987, life is more stable, people move to a place and will stay there for a while
        set household-time household-age - 3 ;;how long they lived in current house
        set household-status 1 ;;household: 0 means new settlers; 1 means settlers; 2 means want to move
        set household-revenue (random-normal 21976 2000)
        set household-saving household-revenue * Householdsave-rate * household-time]

      set com gis:find-one-feature neib-boundary "CID" (word community)
      set com-households gis:property-value com "Family9"
      set unit-households (com-households / total-land / simul-ratio)
;      ask communitys with [community-ID = community][
;        set unit-households round (community-BDHS / total-land / simul-ratio)] ;;to reduce run time divide by 10
      sprout-households unit-households[
        set shape "dot"
        set color black
        set size 1
        set community-b-id community
        set household-age 3 + abs(random 5) * 0.1 + 9
        ;;before 1987, life is more stable, people move to a place and will stay there for a while
        set household-time household-age - 3 ;;how long they lived in current house
        set household-status 1 ;;household: 0 means new settlers; 1 means settlers; 2 means want to move
        set household-revenue (random-normal 21976 2000)
        set household-saving household-revenue * Householdsave-rate * household-time]

      set com gis:find-one-feature neib-boundary "CID" (word community)
      set com-households gis:property-value com "Family10"
      set unit-households (com-households / total-land / simul-ratio)
;      ask communitys with [community-ID = community][
;        set unit-households round (community-BDHS / total-land / simul-ratio)] ;;to reduce run time divide by 10
      sprout-households unit-households[
        set shape "dot"
        set color black
        set size 1
        set community-b-id community
        set household-age 3 + abs(random 5) * 0.1 + 10
        ;;before 1987, life is more stable, people move to a place and will stay there for a while
        set household-time household-age - 3 ;;how long they lived in current house
        set household-status 1 ;;household: 0 means new settlers; 1 means settlers; 2 means want to move
        set household-revenue (random-normal 21976 2000)
        set household-saving household-revenue * Householdsave-rate * household-time]
      ]
end

;;household age 0-15:1, 15-25:2,25-35:3,35-45:4,45-55:5,55-65:6,65-75:7,>75:8
to new-immi-households [NHS]
    create-households NHS[
    set shape "dot"
    set color blue
    set size 1
    set household-age 3 + abs(random-normal 0 1) * 2
    set household-time 0
    set household-status 0
    ;;annual household revenue is 3817 per person, household revenue total is 473.61, saving is 200.29 and consumption is 184.68
    ;;1988 year book page 53
    set household-revenue (random-normal 21976 2000)
    ;;suppose the downpayment is 5 times of annual saving and the rest is 20 years mortgate payment
    set household-saving (random-normal 21976 2000) * Householdsave-rate * 5]
end

to go
  if ticks > 20 [stop]
  new-immi-households (count households) * Household-Increase
  land-development
  community-update
  household-settle
  community-update
;  GAResult

  land-interchange
  landuse-household-report
  save
  tick
end
;;compare with residential land use of 2013
;;for R parameter estimation
;to GAResult
;  let ICResult 0
;  set GAIResult 0
;  ask patches with [land-status = 1][
;    if land-status = 1 and land-2013 = 1[set ICResult ICResult + 1]]
;  set GAIResult precision (ICResult / (count patches with [land-2013 = 1])) 3
;end

to land-development
;    let Land-increase round (interchange-land + (((count households) * 0.12) + (count households with [household-status = 2]) * ((random 10) * 0.1 * ticks + 1)) * no-vacancy-rate)
    let Land-increase round (land-supply / 30)
    let best-children SGA round Land-increase

    foreach sort best-children[ask ?[
          set land-status 1
          set pcolor black]]
end

to household-settle

  ask households with [household-status = 2][
      let a-community community-b-id
      let b-community best-fit-community self

      move-to one-of patches with [community-belong = b-community and land-status = 1 and (count households-here) < max-households]

      set community-b-id b-community
      set household-saving household-saving - household-revenue * Householdsave-rate * 5
      set household-status 1
      set household-time 0
      set household-age household-age + 0.1
      set household-revenue household-revenue * (1 + Householdrevenue-Increaserate)

      ask communitys with [community-ID = a-community][set c-vacancy-houses c-vacancy-houses + 1]
      ask communitys with [community-ID = b-community][set c-vacancy-houses c-vacancy-houses - 1]

      set color red
      set size 1]

  ask households with [household-status = 0][

    let b-community best-fit-community self
    move-to one-of patches with [community-belong = b-community and land-status = 1 and (count households-here) < max-households]

    ask communitys with [community-ID = b-community][set c-vacancy-houses c-vacancy-houses - 1]

    set community-b-id b-community
    set household-saving household-saving - household-revenue * Householdsave-rate * 5
    set household-status 1
    set household-time 0
    set household-age household-age + 0.1
    set household-revenue household-revenue * (1 + Householdrevenue-Increaserate)
    set color 112
    set size 1]

  ask households with[household-status = 1][
    ;;move out or die according to age
    let OP exp(- Die-out * abs(household-age - 8))
    if OP > TH-dieout[die]

    set household-age household-age + 0.1
    set household-time household-time + 1
    set household-revenue household-revenue * (1 + Householdrevenue-Increaserate)
    set household-saving household-saving + household-revenue * Householdsave-Rate

    ;;check if current household still fit the current community
    let community [community-belong] of patch-here
    let household-cohension cohension household-age household-revenue community

    if(household-status = 1 and household-time > household-fix and household-cohension > 0.5 + random-float 0.5 and household-saving >= household-revenue * 5)[
        set household-status 2]
    set color 112
    set size 1]

end


;;update all communities
to community-update
  ask communitys[
    let id community-ID

    set total-households count households with [community-b-id = id]

    carefully[set avg-household-age mean [household-age] of households with [community-b-id = id]]
    [set avg-household-age 0]
    carefully[set avg-household-revenue mean [household-revenue] of households with [community-b-id = id]]
    [set avg-household-revenue 0]

    set c-vacancy-houses round ((sum [max-households] of patches with [community-belong = id and land-status = 1 ]) - total-households)

;    ;;community enviroment
;    let avg-to-metro mean [distometro] of patches with [community-belong = id]
;    let avg-developed (count patches with [community-belong = id and land-status = 1]) / total-lands
;    set community-suit exp(- avg-to-metro) + exp (-(1 - avg-developed)) + exp(- c-vacancy-houses)

    ;;use standar deviation as indicator for community cohension
    ifelse (total-households > 1)[
      set cohension-value (standard-deviation [household-age] of households with [community-b-id = id] + standard-deviation [household-revenue] of households with [community-b-id = id])]
    [set cohension-value 0]

    ]
end

;;select the bet fit community for current household
;;with big cohension value
to-report best-fit-community[household]
  ;;create a list of cohension values of all communities
  ;;consider community
  let fc max-n-of 10 communitys with [c-vacancy-houses > 1] [community-suit]
  ;;consider suitability
  let fb min-n-of 5 fc [cohension-value]
  let f-community [community-ID] of one-of fb
  report f-community
end

to-report cohension[householdage householdrevenue communityid]
  let cohensionvalue 0
  ask communitys with [community-ID = communityid][
    set cohensionvalue abs (householdage - avg-household-age) / max [household-age] of households + abs (householdrevenue - avg-household-revenue)/ max [household-revenue] of households]
  report cohensionvalue
end


to land-interchange
  ;;change empty land into agri and add land quation to next year
  set interchange-land 0
  ask patches with [count households-here = 0 and land-status = 1 and count neighbors with [land-status = 1] < 2][
    set land-status 0
    set interchange-land interchange-land + 1]
  set-current-plot "Inter Exchange Land"
  set-current-plot-pen "Land"
  plot (interchange-land * 3600)
end

;;land supply model
to-report land-supply
  let max-distance [distocenter] of max-one-of patches with[land-status = 0] [distocenter]

  let total-supply 0
  ask patches with [land-status = 0][
    set total-supply total-supply + round exp(- distocenter / max-distance)]
  report total-supply
end

;;-------------------------------------------------------------------------------------------------------------
;;spatial genetic algoriths
to-report SGA [communitylandincrease]
 set GA-parent1 reproduction communitylandincrease
 set GA-parent2 reproduction communitylandincrease
 set GA-parent3 reproduction communitylandincrease
 set GA-parent4 reproduction communitylandincrease

 let i 0
 let b-children GA-parent1
 while [i < generation][

  ;;create four parents, one from existing land use
  pre-selection b-children
  ;crossover
  let s random 3

  if s = 0 [
    crossover GA-parent1 GA-parent2
    crossover GA-parent3 GA-parent4]

  if s = 1 [
    crossover GA-parent1 GA-parent3
    crossover GA-parent2 GA-parent4]

  if s = 2 [
    crossover GA-parent1 GA-parent4
    crossover GA-parent2 GA-parent3]

  set b-children elitism-children b-children communitylandincrease
  set i i + 1]
 report b-children
end

to pre-selection [b-children]
  let parent-fit []
  set parent-fit lput (calculate-suit GA-parent1) parent-fit
  set parent-fit lput (calculate-suit GA-parent2) parent-fit
  set parent-fit lput (calculate-suit GA-parent3) parent-fit
  set parent-fit lput (calculate-suit GA-parent4) parent-fit

  let p-fit-list []
  let i 0
  repeat 4 [
    set p-fit-list lput ((item i parent-fit) /(sum parent-fit + 1)) p-fit-list  ;;+ 1 to make sure the division is not zero
    set i i + 1]

  let p1 GA-parent1
  let p2 GA-parent2
  let p3 GA-parent3
  let p4 GA-parent4

  let gp1 wheel-selection p-fit-list
  let gp2 wheel-selection p-fit-list
  let gp3 wheel-selection p-fit-list
  let gp4 wheel-selection p-fit-list

  if (gp1 = 1)[set GA-parent1 p1]
  if (gp1 = 2)[set GA-parent1 p2]
  if (gp1 = 3)[set GA-parent1 p3]
  if (gp1 = 4)[set GA-parent1 p4]

  if (gp2 = 1)[set GA-parent2 p1]
  if (gp2 = 2)[set GA-parent2 p2]
  if (gp2 = 3)[set GA-parent2 p3]
  if (gp2 = 4)[set GA-parent2 p4]

  if (gp3 = 1)[set GA-parent3 p1]
  if (gp3 = 2)[set GA-parent3 p2]
  if (gp3 = 3)[set GA-parent3 p3]
  if (gp3 = 4)[set GA-parent3 p4]

  if (gp4 = 1)[set GA-parent4 p1]
  if (gp4 = 2)[set GA-parent4 p2]
  if (gp4 = 3)[set GA-parent4 p3]
  if (gp4 = 4)[set GA-parent4 p4]
end

to-report wheel-selection [pfitlist]
  let parent []
   let ran random-float 1
   if ran <= item 0 pfitlist[set parent 1]
   if ran > item 0 pfitlist and ran <= (item 0 pfitlist + item 1 pfitlist) [set parent 2]
   if ran > item 1 pfitlist and ran <= (item 1 pfitlist + item 2 pfitlist) [set parent 3]
   if ran > item 2 pfitlist [set parent 4]
  report parent
end

to-report reproduction [n-s]
;  let s-patches n-patches patches with [land-status = 0 and count neighbors with [land-status = 1] > 1]
;  let s-patches n-of n-s patches with [community-belong = communityid and land-status = 0 and (count neighbors with [land-status = 1]) > 1]

let s-patches ""
carefully
  [set s-patches n-of n-s patches with [community-belong > 0 and land-status = 0 and (count neighbors with [land-status = 1]) > 0]]
  [let availalbe-patches count patches with [community-belong > 0 and land-status = 0 and (count neighbors with [land-status = 1]) > 0 ]
    let s1-patches n-of availalbe-patches patches with [community-belong > 0 and land-status = 0 and (count neighbors with [land-status = 1]) > 0]
    let s2-patches n-of (n-s - availalbe-patches) patches with [community-belong > 0 and land-status = 0]
    set s-patches (patch-set s1-patches s2-patches)]
  report s-patches
end

to crossover [parent1 parent2]
  let i count parent1
  let j count parent2
  let together (patch-set parent1 parent2)
  set parent1 n-of i together
  set parent2 n-of j together
end

to-report mutation [parent]
  let m-location random (length parent)
  ifelse (item m-location parent = 0)
  [set parent replace-item m-location parent 1]
  [set parent replace-item m-location parent 0]
  report parent
end

;;Maximization of compactness
to-report elitism-children [bchildren communitylandincrease]
  let p []
  let b-children []

  set p lput calculate-suit GA-parent1 p
  set p lput calculate-suit GA-parent2 p
  set p lput calculate-suit GA-parent3 p
  set p lput calculate-suit GA-parent4 p
  set p lput calculate-suit bchildren p

  let location-m position (max p) p
  let location-s position (min p) p

  if (location-m = 0) [set b-children GA-parent1]
  if (location-m = 1) [set b-children GA-parent2]
  if (location-m = 2) [set b-children GA-parent3]
  if (location-m = 3) [set b-children GA-parent4]
  if (location-m = 4) [set b-children bchildren]

  if (location-m = 0) [set GA-parent1 reproduction communitylandincrease]
  if (location-m = 1) [set GA-parent2 reproduction communitylandincrease]
  if (location-m = 2) [set GA-parent3 reproduction communitylandincrease]
  if (location-m = 3) [set GA-parent4 reproduction communitylandincrease]

  report b-children
end

;;objective function
;;calculate suitability
to-report calculate-suit [parent]
  ;;compatability
  let s1-compact 0
  let s2-metro 0
  let s3-center 0
  let s4-community 0
  let s5-environ 0
  let max-c max [cohension-value] of communitys + 1
  let max-vr max[avg-household-revenue] of communitys + 1

  ask parent[
    let id community-belong
    set s1-compact s1-compact + s-compact * (count neighbors with [land-status = 1]) / 8 - s-compat * (count neighbors with [land-status = 2] + 1) / 8
    set s2-metro s2-metro + exp(- s-metro * distometro)
    set s3-center s3-center + exp(- s-center * distocenter)
    set s4-community s4-community + t1 * exp(([cohension-value] of one-of communitys with [community-ID = id]) / max-c)
        + t2 * exp(([avg-household-revenue] of one-of communitys with [community-ID = id]) / max-vr)
    set s5-environ s5-environ + (u1 * (count patches with [community-belong = id and land-status = 3])
    - u2 * (count patches with [community-belong = id and land-status = 4])) / (count patches with [community-belong = id])]

  let s omiga1 * s1-compact + omiga2 * (r1 * s2-metro + r2 * s3-center) + omiga3 * s4-community + omiga4 * s5-environ
  report s
end

;;need to be finished
to landuse-household-report
  ;;calculate vancancy rate
  let total-max-households (sum [max-households] of patches with [land-status = 1])
  let no-vacancy-rate (count households) * simul-ratio / total-max-households
  set-current-plot "House Vacancy Rate"
  set-current-plot-pen "Vacancy Rate"
  plot (100 - no-vacancy-rate * 100)
end

to save
;  if file-exists? "FinalLanduse.txt"
;  [file-delete "FinalLanduse.txt"]
;
;  file-open "FinalLanduse.txt"
;  foreach sort patches[ask ?
;  [file-write land-status]]
;  file-close


;  let praster gis:patch-dataset lprice

  ask patches[if land-status = -9999[set land-status 999]]
  let llandresult gis:patch-dataset land-status
  gis:store-dataset llandresult word "llandresult" ticks

  file-open (word "communityyear" ticks)
  foreach sort communitys[ask ?[
    file-write community-ID file-write total-households file-write cohension-value file-write c-vacancy-houses file-write community-suit file-write avg-household-age file-write avg-household-revenue]]
  file-close
end
@#$#@#$#@
GRAPHICS-WINDOW
324
24
1180
733
-1
-1
3.442
1
10
1
1
1
0
1
1
1
0
245
0
196
0
0
1
Year
30.0

BUTTON
9
26
72
59
Initial
Initial
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
84
26
148
59
go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
158
25
221
58
Save
Save
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

INPUTBOX
328
758
483
818
Generation
10
1
0
Number

INPUTBOX
164
92
319
152
Householdrevenue-Increaserate
0.1
1
0
Number

INPUTBOX
7
153
162
213
Householdsave-Rate
0.5
1
0
Number

PLOT
1185
238
1648
473
House Vacancy Rate
year
vacandy
0.0
20.0
0.0
100.0
true
false
"" ""
PENS
"Vacancy Rate" 1.0 0 -2674135 true "" ""

MONITOR
1403
132
1530
177
household
(count households) * Simul-ratio
17
1
11

PLOT
1184
481
1651
732
Inter Exchange Land
year
Exchanged Land (square meters)
0.0
20.0
3600.0
20000.0
true
false
"" ""
PENS
"Land" 1.0 0 -14439633 true "" ""

TEXTBOX
1191
140
1470
170
Total householders in the study area:
12
0.0
1

TEXTBOX
1193
187
1463
217
Total homes built in the study area:
12
0.0
1

MONITOR
1403
181
1533
226
houses
round ((sum [max-households] of patches with [land-status = 1]))
17
1
11

MONITOR
1402
83
1529
128
Year
1987 + ticks
17
1
11

INPUTBOX
8
92
163
152
Household-Increase
0.12
1
0
Number

TEXTBOX
9
62
333
80
-------------------------------------------------------------------------------
11
0.0
1

TEXTBOX
9
73
257
107
Population dynamics & Urban land use
14
0.0
1

TEXTBOX
329
741
529
759
Spatial Genetic Algorithms
14
0.0
1

TEXTBOX
328
733
650
751
--------------------------------------------------------------------------------
11
0.0
1

INPUTBOX
484
758
639
818
Crossover-rate
0.8
1
0
Number

INPUTBOX
6
384
161
444
s-metro
800
1
0
Number

INPUTBOX
165
217
319
277
household-fix
3
1
0
Number

INPUTBOX
164
153
319
213
Simul-ratio
1
1
0
Number

INPUTBOX
6
303
161
363
Die-out
1
1
0
Number

INPUTBOX
162
303
317
363
TH-dieout
0.3
1
0
Number

INPUTBOX
162
384
317
444
s-center
700
1
0
Number

INPUTBOX
6
508
161
568
s-compact
0.2
1
0
Number

INPUTBOX
162
508
317
568
s-compat
0.3
1
0
Number

INPUTBOX
6
446
161
506
r1
0.1
1
0
Number

INPUTBOX
162
447
317
507
r2
0.2
1
0
Number

INPUTBOX
7
694
162
754
omiga1
0.1
1
0
Number

INPUTBOX
164
694
319
754
omiga2
0.8
1
0
Number

INPUTBOX
7
757
162
817
omiga3
0.4
1
0
Number

INPUTBOX
164
758
319
818
omiga4
0.9
1
0
Number

INPUTBOX
7
570
162
630
t1
0.7
1
0
Number

INPUTBOX
163
571
318
631
t2
0.1
1
0
Number

INPUTBOX
7
632
162
692
u1
0.4
1
0
Number

INPUTBOX
163
633
318
693
u2
1
1
0
Number

TEXTBOX
8
285
277
313
Coefficient and threshold of age on move out or die:
11
0.0
1

TEXTBOX
1193
95
1343
115
Simulation year:
16
0.0
1

TEXTBOX
1196
40
1346
65
Model Outputs:
20
0.0
1

TEXTBOX
1192
66
1629
108
------------------------------------------------------------------------------------------------------
11
0.0
1

TEXTBOX
8
369
183
397
Land development coefficients:
11
0.0
1

TEXTBOX
8
223
158
265
The number of years a household is not allowed to move:
11
0.0
1

@#$#@#$#@
## WHAT IS IT?

>>1.model is using spatial GA, there is a balance of landuse crossover
>>2.model is integrating with R as display results
>>3.model gets back to the whole city
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.2.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
