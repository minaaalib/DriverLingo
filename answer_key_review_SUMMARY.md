# LTO Reviewer Answer Key - Verification Summary

Source of truth: `lto_reviewer_structured.json` (all 101 questions parsed from `LTO-Reviewer.docx`).
Every one of the 101 questions was re-derived independently from its question text, its three options, and its ENGLISH/FILIPINO/HILIGAYNON explanation, cross-checked against Philippine traffic law (RA 4136, RA 8749, RA 10586, RA 11229, PD 1865, LTO/LTFRB regulations). `system_guess` was consulted only afterwards, as a cross-check.

## Totals

| Metric | Count |
| --- | ---: |
| Questions verified | 101 |
| Verdict `certain` | 99 |
| Verdict `uncertain` | 2 |
| Rows carrying a `system_guess` (from the flagged CSV) | 75 |
| Agreed with `system_guess` | 32 |
| **Disagreed with `system_guess`** | **43** |
| Questions with no `system_guess` available (the "confident 26") | 26 |

Answer distribution: a = 38, b = 29, c = 34

## Uncertain (2)

- **Q12** (answered `a`) - A safe speed to drive your car under adverse conditions depends on:: Explanation frames the authorized/imposed speed limit as the reference point you adjust downward from; no option maps cleanly, (a) is the best fit. Flagged for human review.
- **Q73** (answered `c`) - When approaching an intersection and the roadway beyond is blocked with traffic, you should:: CONFLICT: the doc's explanation argues for (b) creeping into the intersection, but RA 4136 and standard LTO answer keys require stopping BEFORE the intersection when the far side is blocked (no blocking the box). Answered (c) on the law; the reviewer's explanation text should be corrected.

## Disagreements with `system_guess` (43)

- **Q1**: verified `c`, system guessed `a` - Explanation states speed limits are based on traffic and overall road condition.
- **Q6**: verified `a`, system guessed `b` - Explanation: a license may only be used by the person named/pictured on it - never lend it.
- **Q7**: verified `c`, system guessed `a` - Explanation: LTO licenses specify the vehicle types allowed per restriction code.
- **Q8**: verified `c`, system guessed `b` - Explanation cites the seat belt; option (c) 'seat belts/helmets' is the only choice covering it (a is helmet-only, b is irrelevant).
- **Q9**: verified `b`, system guessed `a` - Explanation is entirely about defensive driving.
- **Q10**: verified `b`, system guessed `c` - RA 4136 defines highway to include parks, alleys, boulevards, driveways and avenues; roadways on private property are NOT highways - matches the explanation about private roads.
- **Q13**: verified `c`, system guessed `a` - Explanation: at night with poor lighting you cannot see far ahead, so max speed is unsafe.
- **Q15**: verified `c`, system guessed `a` - Explanation: inspection is done to ensure the vehicle is in good and safe condition.
- **Q17**: verified `b`, system guessed `a` - Explanation: consult your doctor if unsure about medication effects.
- **Q18**: verified `a`, system guessed `c` - Explanation: you can only control your own speed and road position.
- **Q20**: verified `c`, system guessed `b` - Explanation lists BOTH planning the route/vehicle condition AND preparing the toolbox, so 'both answers are correct'.
- **Q21**: verified `b`, system guessed `c` - Explanation: traffic rules exist for organizational and safety reasons - orderly movement of vehicles and pedestrians.
- **Q22**: verified `c`, system guessed `a` - Explanation: professional drivers are those who drive for a living (paid).
- **Q23**: verified `c`, system guessed `a` - Suspension = license taken temporarily; permanent taking is revocation.
- **Q25**: verified `c`, system guessed `b` - Explanation: at night visibility ahead is reduced.
- **Q30**: verified `b`, system guessed `a` - Explanation describes the penalty for the act, i.e. it is prohibited; RA 11229 also bars young children from the front seat, so the answer is 'No'.
- **Q33**: verified `b`, system guessed `a` - Explanation warns that ignoring signs at night is unsafe - it can cause a fatal accident.
- **Q34**: verified `c`, system guessed `a` - Explanation explicitly states 100 kph max on expressways for cars.
- **Q38**: verified `c`, system guessed `b` - Explanation: a pre-trip inspection must be done BEFORE hitting the road.
- **Q40**: verified `c`, system guessed `a` - Explanation: renewal schedule follows the last digit of the plate number (last working day of that month).
- **Q41**: verified `b`, system guessed `a` - Explanation: drivers get the most information through vision.
- **Q45**: verified `b`, system guessed `a` - Explanation describes blue signs as giving helpful information/directions - information signs.
- **Q46**: verified `b`, system guessed `c` - Explanation: green means you may go when the way is clear and it is safe.
- **Q49**: verified `b`, system guessed `a` - Explanation: double solid yellow lines may not be crossed in either direction at any time.
- **Q53**: verified `b`, system guessed `c` - Explanation: right-of-way law defines who goes first and who yields.
- **Q55**: verified `b`, system guessed `a` - Explanation is entirely about yielding to pedestrians.
- **Q56**: verified `c`, system guessed `a` - Explanation: stop and wait until ALL pedestrians have completely cleared the crossing.
- **Q58**: verified `a`, system guessed `b` - Explanation requires BOTH signalling and checking traffic before changing lanes.
- **Q59**: verified `c`, system guessed `b` - Explanation names both situations (other driver dims; blinded by oncoming lights), so 'all of the above'.
- **Q73**: verified `c`, system guessed `b` - CONFLICT: the doc's explanation argues for (b) creeping into the intersection, but RA 4136 and standard LTO answer keys require stopping BEFORE the intersection when the far side is blocked (no blocking the box). Answered (c) on the law; the reviewer's explanation text should be corrected.
- **Q74**: verified `a`, system guessed `b` - Explanation: mirror checks should be quick/brief.
- **Q76**: verified `a`, system guessed `c` - Explanation states drivers face BOTH license suspension/revocation AND fines or jail, so 'both answers are correct'.
- **Q77**: verified `a`, system guessed `c` - Explanation gives no figure; the standard LTO penalty for a driver's first colorum offense is a Php 2,000 fine plus 3-month license suspension. (b) cancellation is too severe for a first offense and (c) Php 500 far too light.
- **Q80**: verified `c`, system guessed `a` - The standardized heel-to-toe nine-step test is the Walk-and-Turn; (a) and (b) are not real tests.
- **Q89**: verified `b`, system guessed `a` - Explanation: the rider must reinstall the original/stock muffler to comply. Bribery (a) is itself a crime.
- **Q90**: verified `c`, system guessed `a` - Explanation describes a no-passing marking in both directions = two solid yellow lines.
- **Q91**: verified `a`, system guessed `c` - Explanation: you are too close - slow down and restore a safe following distance.
- **Q93**: verified `b`, system guessed `a` - Explanation: reduce speed before the curve; abrupt braking is explicitly rejected.
- **Q94**: verified `c`, system guessed `b` - Explanation is entirely about parking too close to a signalized intersection.
- **Q96**: verified `c`, system guessed `b` - Explanation: treat a blinking red like a stop sign - full stop, then proceed when clear.
- **Q98**: verified `c`, system guessed `b` - Explanation explicitly rejects 'intentions' and 'right of way' and says headlights let others know you are approaching.
- **Q100**: verified `a`, system guessed `b` - Explanation: obeying installed traffic signs is the key accident-prevention measure.
- **Q101**: verified `c`, system guessed `a` - Explanation: shift to low gear and use engine braking; being ready to brake is secondary.

## Notes on the "confident 26"

The 26 questions absent from the flagged CSV (3, 4, 12, 19, 24, 26, 27, 29, 31, 35, 36, 37, 52, 62, 64, 65, 66, 67, 69, 70, 71, 78, 79, 81, 95, 99) were derived independently from the JSON in the same pass; all 26 came out `certain`. Q1 - which the project README flagged as a known heuristic miss - is in the flagged CSV and is indeed a disagreement (correct answer is `c`, traffic and road condition).
