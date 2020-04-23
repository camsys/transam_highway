# -----------------------------------------------
#
# Service to handle NBI export format
# 5 Inventory Route 19 - 27 9/AN
# 5A Record Type 19 1/AN
# 5B Route Signing Prefix 20 1/N
# 5C Designated Level of Service 21 1/N
# 5D Route Number 22 - 26 5/AN
# 5E Directional Suffix 27 1/N
# 2 Highway Agency District 28 - 29 2/AN
# 3 County (Parish) Code 30 - 32 3/N
# 4 Place Code 33 - 37 5/N
# 6 Features Intersected 38 - 62 25/AN
# 6A Features Intersected 38 - 61 24/AN
# 6B Critical Facility Indicator 62 1/AN
# 7 Facility Carried By Structure 63 - 80 18/AN
# 9 Location 81 - 105 25/AN
# 10 Inventory Rte, Min Vert Clearance 106 - 109 4/N
# 11 Kilometerpoint 110 - 116 7/N
# 12 Base Highway Network 117 1/N
# 13 Inventory Route, Subroute Number 118 - 129 12/AN
# 13A LRS Inventory Route 118 - 127 10/AN
# 13B Subroute Number 128 - 129 2/N
# 16 Latitude 130 - 137 8/N
# 17 Longitude 138 - 146 9/N
# 19 Bypass/Detour Length 147 - 149 3/N
# 20 Toll 150 1/N
# 21 Maintenance Responsibility 151 - 152 2/N
# 22 Owner 153 - 154 2/N
# 26 Functional Class Of Inventory Rte.155 - 156 2/N
# 27 Year Built 157 - 160 4/N
# 28 Lanes On/Under Structure 161 - 164 4/N
# 28A Lanes On Structure 161 - 162 2/N
# 28B Lanes Under Structure 163 - 164 2/N
# 29 Average Daily Traffic 165 - 170 6/N
# 30 Year Of Average Daily Traffic 171 - 174 4/N
# 31 Design Load 175 1/N
# 32 Approach Roadway Width 176 - 179 4/N
# 33 Bridge Median 180 1/N
# 34 Skew 181 - 182 2/N
# 35 Structure Flared 183 1/N
# E-1
# ITEM ITEM ITEM
# NO ITEM NAME POSITION LENGTH/TYPE
# 36 Traffic Safety Features 184 - 187 4/AN
# 36A Bridge Railings 184 1/AN
# 36B Transitions 185 1/AN
# 36C Approach Guardrail 186 1/AN
# 36D Approach Guardrail Ends 187 1/AN
# 37 Historical significance 188 1/N
# 38 Navigation Control 189 1/AN
# 39 Navigation Vertical Clearance 190 - 193 4/N
# 40 Navigation Horizontal Clearance 194 - 198 5/N
# 41 Structure Open/Posted/Closed 199 1/AN
# 42 Type Of Service 200 - 201 2/N
# 42A Type of Service On Bridge 200 1/N
# 42B Type of Service Under Bridge 201 1/N
# 43 Structure Type, Main 202 - 204 3/N
# 43A Kind of Material/Design 202 1/N
# 43B Type of Design/Construction 203 - 204 2/N
# 44 Structure Type, Approach Spans 205 - 207 3/N
# 44A Kind of Material/Design 205 1/N
# 44B Type of Design/Construction 206 - 207 2/N
# 45 Number Of Spans In Main Unit 208 - 210 3/N
# 46 Number Of Approach Spans 211 - 214 4/N
# 47 Inventory Rte Total Horz Clearance215 - 217 3/N
# 48 Length Of Maximum Span 218 - 222 5/N
# 49 Structure Length 223 - 228 6/N
# 50 Curb/Sidewalk Widths 229 - 234 6/N
# 50A Left Curb/Sidewalk Width 229 - 231 3/N
# 50B Right Curb/Sidewalk Width 232 - 234 3/N
# 51 Bridge Roadway Width Curb-To-Curb 235 - 238 4/N
# 52 Deck Width, Out-To-Out 239 - 242 4/N
# 53 Min Vert Clear Over Bridge Roadway243 - 246 4/N
# 54 Minimum Vertical Underclearance 247 - 251 5/AN
# 54A Reference Feature 247 1/AN
# 54B Minimum Vertical Underclearance 248 - 251 4/N
# 55 Min Lateral Underclear On Right 252 - 255 4/AN
# 55A Reference Feature 252 1/AN
# 55B Minimum Lateral Underclearance 253 - 255 3/N
# 56 Min Lateral Underclear On Left 256 - 258 3/N
# 58 Deck 259 1/AN
# 59 Superstructure 260 1/AN
# 60 Substructure 261 1/AN
# 61 Channel/Channel Protection 262 1/AN
# 62 Culverts 263 1/AN
# E-2
# ITEM ITEM ITEM
# NO ITEM NAME POSITION LENGTH/TYPE
# 63 Method Used To Determine Operating
# Rating 264 1/N
# 64 Operating Rating 265 - 267 3/N
# 65 Method Used To Determine Inventory
# Rating 268 1/N
# 66 Inventory Rating 269 - 271 3/N
# 67 Structural Evaluation 272 1/AN
# 68 Deck Geometry 273 1/AN
# 69 Underclear, Vertical & Horizontal 274 1/AN
# 70 Bridge Posting 275 1/N
# 71 Waterway Adequacy 276 1/AN
# 72 Approach Roadway Alignment 277 1/AN
# 75 Type of Work 278 - 280 3/N
# 75A Type of Work Proposed 278 - 279 2/N
# 75B Work Done By 280 1/AN
# 76 Length Of Structure Improvement 281 - 286 6/N
# 90 Inspection Date 287 - 290 4/N
# 91 Designated Inspection Frequency 291 - 292 2/N
# 92 Critical Feature Inspection 293 - 301 9/AN
# 92A Fracture Critical Details 293 - 295 3/AN
# 92B Underwater Inspection 296 - 298 3/AN
# 92C Other Special Inspection 299 - 301 3/AN
# 93 Critical Feature Inspection Dates 302 - 313 12/AN
# 93A Fracture Critical Details Date 302 - 305 4/AN
# 93B Underwater Inspection Date 306 - 309 4/AN
# 93C Other Special Inspection Date 310 - 313 4/AN
# 94 Bridge Improvement Cost 314 - 319 6/N
# 95 Roadway Improvement Cost 320 - 325 6/N
# 96 Total Project Cost 326 - 331 6/N
# 97 Year Of Improvement Cost Estimate 332 - 335 4/N
# 98 Border Bridge 336 - 340 5/AN
# 98A Neighboring State Code 336 - 338 3/AN
# 98B Percent Responsibility 339 - 340 2/N
# 99 Border Bridge Structure Number 341 - 355 15/AN
# 100 STRAHNET Highway Designation 356 1/N
# 101 Parallel Structure Designation 357 1/AN
# 102 Direction Of Traffic 358 1/N
# 103 Temporary Structure Designation 359 1/AN
# 104 Highway System Of Inventory Route 360 1/N
# 105 Federal Lands Highways 361 1/N
# 106 Year Reconstructed 362 - 365 4/N
# 107 Deck Structure Type 366 1/AN
# 108 Wearing Surface/Protective System 367 - 369 3/AN
# 108A Type of Wearing Surface 367 1/AN
# 108B Type of Membrane 368 1/AN
# 108C Deck Protection 369 1/AN
# E-3
# ITEM ITEM ITEM
# NO ITEM NAME POSITION LENGTH/TYPE
# 109 AVERAGE DAILY TRUCK TRAFFIC 370 - 371 2/N
# 110 DESIGNATED NATIONAL NETWORK 372 1/N
# 111 PIER/ABUTMENT PROTECTION 373 1/N
# 112 NBIS BRIDGE LENGTH 374 1/AN
# 113 SCOUR CRITICAL BRIDGES 375 1/AN
# 114 FUTURE AVERAGE DAILY TRAFFIC 376 - 381 6/N
# 115 YEAR OF FUTURE AVG DAILY TRAFFIC 382 - 385 4/N
# 116 MINIMUM NAVIGATION VERTICAL 386 - 389 4/N
# CLEARANCE VERTICAL LIFT BRIDGE
# --- Washington Headquarters Use 392 - 426
# STATUS 427
# n/a Asterisk Field in SR 428 1/AN
# SR SUFFICIENCY RATING 429 - 432 4/N

#
# -----------------------------------------------

class NbiSubmissionGenerator
  @@state_code = Rails.application.config.state_code

  def self.nbi_for_structure(structure)
    # Check for bridge

    result = ""
    # for each roadway

    # ITEM   ITEM               ITEM
    # NO     NAME               POSITION    LENGTH/TYPE
    # 1      State Code         1 - 3       3/N
    result << @@state_code
    # 8      Structure Number   4 - 18      15/AN
    result << structure.structure_number.ljust(15)
    # 5      Inventory Route   19 - 27      9/AN
    roadway = structure.roadways.on.first || structure.roadways.under.first
    if roadway
    # 5A     Record Type          19        1/AN
      result << roadway.on_under_indicator
    # 5B     Route Signing Prefix 20        1/N
    # 5C     Des. Level Service   21        1/N
    # 5D     Route Number      22 - 26      5/AN
    # 5E     Directional Suffix   27        1/N
    else
      result << '         '
    end

    # Check expected string length

    result
  end

  def self.nbi_for_list(inspections)
    HighwayStructure.where(id: inspections.pluck(:transam_asset_id).uniq).collect{ |hs| nbi_for_structure(hs) }.join("\n")
  end
end
