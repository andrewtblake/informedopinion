require_relative "fact_bank"

SEX_WORK_DECRIMINALISATION_OPINION = {
  slug: "decriminalising-sex-work",
  title: "Decriminalising sex work",
  statement: "England and Wales should remove criminal penalties that apply specifically to the consensual buying and selling of sexual services between adults, while retaining laws against coercion, trafficking and sexual exploitation.",
  response_options: [ "Strongly agree", "Somewhat agree", "Neither agree nor disagree", "Somewhat disagree", "Strongly disagree" ],
  display_order: 14,
  accent: "rose",
  category: "Society & law",
  tags: [ "Sex work", "Criminal law", "Sexual exploitation", "Public safety", "England and Wales" ]
}.freeze

SEX_WORK_SOURCES = {
  cps: [ "Crown Prosecution Service: Prostitution and exploitation of prostitution", "https://www.cps.gov.uk/prosecution-guidance/prostitution-and-exploitation-prostitution" ],
  home_office: [ "Home Office: Nature and prevalence of prostitution and sex work", "https://www.gov.uk/government/publications/nature-of-prostitution-and-sex-work-in-england-and-wales" ],
  committee: [ "House of Commons Home Affairs Committee: Prostitution", "https://publications.parliament.uk/pa/cm201617/cmselect/cmhaff/26/2607.htm" ],
  street_act: [ "legislation.gov.uk: Street Offences Act 1959", "https://www.legislation.gov.uk/ukpga/Eliz2/7-8/57/section/1" ],
  policing_act: [ "legislation.gov.uk: Policing and Crime Act 2009 explanatory notes", "https://www.legislation.gov.uk/ukpga/2009/26/notes/division/5/2" ],
  sexual_act: [ "legislation.gov.uk: Sexual Offences Act 2003", "https://www.legislation.gov.uk/ukpga/2003/42/part/1/crossheading/exploitation-of-prostitution" ],
  modern_slavery: [ "legislation.gov.uk: Modern Slavery Act 2015", "https://www.legislation.gov.uk/ukpga/2015/30/contents" ],
  nz_review: [ "New Zealand Ministry of Justice: Prostitution Law Review Committee reports", "https://www.justice.govt.nz/justice-sector-policy/regulatory-stewardship/regulatory-systems/occupational-regulation/" ],
  ni_review: [ "Northern Ireland Department of Justice: Sex-purchase offence impact", "https://www.justice-ni.gov.uk/news/report-published-impact-sex-purchase-offence" ],
  who: [ "World Health Organization: Prevention and treatment of HIV among sex workers", "https://iris.who.int/bitstream/handle/10665/77745/9789241504744_eng.pdf?sequence=1" ],
  police: [ "College of Policing: Protecting sex workers", "https://www.college.police.uk/article/protecting-sex-workers" ]
}.freeze

SEX_WORK_DECRIMINALISATION_FACTS = FactBank.build([
  [ "Is the private consensual exchange of sexual services for payment between two adults itself generally an offence in England and Wales?",
    [ "No", "Yes, for both parties in every setting", "Yes, but only for the seller", "Only when payment is electronic" ], 0,
    "The exchange itself is not generally prohibited, but surrounding conduct—including street solicitation, brothel management, control and some purchasing—is criminalised.", :cps, 0, 3, "The current partial-criminalisation baseline is foundational to understanding what the proposition would change." ],
  [ "Under the Street Offences Act, when can an adult selling sex commit the street-soliciting offence?",
    [ "After any private advertisement", "When persistently loitering or soliciting in a street or public place", "Whenever a client makes an offer", "Only after a court has prohibited all employment" ], 1,
    "The offence concerns persistent loitering or soliciting in a street or public place for prostitution; persistence means two or more occasions within three months.", :street_act, 1, 2, "Seller-side criminal exposure is significant to the proposed removal of sex-work-specific penalties." ],
  [ "What conduct does section 51A of the Sexual Offences Act prohibit?",
    [ "Advertising any lawful adult service online", "Renting a private room", "Soliciting another person in a street or public place to buy sexual services", "Providing sexual-health advice" ], 2,
    "Section 51A criminalises street or public-place solicitation by a prospective buyer; nuisance or persistence need not be proved.", :cps, 0, 2, "Buyer-side street law is significant to distinguishing decriminalisation from unrestricted public solicitation." ],
  [ "When does section 53A make paying for sexual services an offence?",
    [ "Whenever the seller earns income", "Only when the buyer admits coercion", "Only when payment exceeds a statutory amount", "When the seller was subjected to specified exploitative conduct" ], 3,
    "The offence applies where the person paid has been subjected to exploitative conduct likely to induce or encourage the services.", :cps, -1, 3, "Protection against purchasing services shaped by exploitation is foundational to what must remain prohibited." ],
  [ "Must a buyer know about the exploitative conduct to commit the section 53A offence?",
    [ "No; it is strict liability as to that knowledge", "Yes, through a written confession", "Yes, unless payment was cash", "Only if the seller reports it first" ], 0,
    "The payer need not know or ought to know of the exploitation; the legislation makes this element one of strict liability.", :policing_act, -1, 2, "Strict liability materially affects enforcement and the protection potentially altered by reform." ],
  [ "For brothel law in England and Wales, what can be enough for premises to count as a brothel?",
    [ "One person working alone from home", "Two or more people using the premises simultaneously for prostitution", "Any building advertised online", "A premises with more than two bedrooms" ], 1,
    "Case law can treat premises used simultaneously by two or more people for prostitution as a brothel, including some collaborative arrangements.", :cps, 1, 3, "The law's application to people working together for safety is foundational to the decriminalisation case." ],
  [ "Does current brothel law distinguish automatically between an exploitative manager and two independent sex workers sharing premises?",
    [ "Yes, shared premises are always licensed", "Yes, if each keeps separate accounts", "No; both situations can fall within brothel offences", "No, because neither situation is regulated" ], 2,
    "Culpability varies greatly, but brothel offences can reach low-culpability collaborative premises as well as exploitative management.", :cps, 1, 3, "Failure to distinguish collaboration from exploitation is foundational to the proposition's scope." ],
  [ "Would the proposed decriminalisation make human trafficking for sexual exploitation lawful?",
    [ "Yes, for adults", "Yes, if no border is crossed", "Only where a licence exists", "No" ], 3,
    "The proposition expressly retains trafficking and exploitation laws; the Modern Slavery Act offences would remain.", :modern_slavery, 1, 3, "Separating consensual adult conduct from trafficking is foundational to an informed response." ],
  [ "How does criminal law define consent to sexual activity?",
    [ "Agreement by choice with freedom and capacity to choose", "Acceptance of any payment", "Absence of a visible injury", "A contract signed by a third party" ], 0,
    "Consent requires agreement by choice and the freedom and capacity to make that choice; payment does not replace consent.", :cps, 0, 3, "The boundary between consensual conduct and sexual offending is foundational to the proposition." ],
  [ "Would decriminalising consensual adult sex work prevent prosecution for rape or sexual assault against a sex worker?",
    [ "Yes, once payment was discussed", "No", "Only for offences indoors", "Only where the assailant was a client" ], 1,
    "Rape, assault and other sexual offences depend on consent and remain offences regardless of a victim's occupation or payment.", :cps, 1, 2, "Continued protection under general criminal law is significant to evaluating decriminalisation." ],
  [ "What does the Home Office-commissioned study say about a precise national count of sex workers?",
    [ "It is fixed by tax registrations", "It equals the number of street cautions", "Available evidence cannot produce a reliable precise total", "Every worker appears in police data" ], 2,
    "Hidden, mobile and varied markets, inconsistent definitions and incomplete administrative data prevent a reliable national prevalence estimate.", :home_office, 0, 2, "Uncertain scale is significant to honest claims about policy effects and resources." ],
  [ "Where did the Home Office study find that adult sexual services were commonly advertised?",
    [ "Only printed telephone directories", "Only licensed council premises", "Only public streets", "Online as well as in street and indoor settings" ], 3,
    "The market includes online advertising and diverse indoor arrangements alongside a much more visible street sector.", :home_office, 0, 1, "Market diversity is supporting context that cautions against treating street observations as the whole sector." ],
  [ "Does the population involved in selling sex consist of one gender and one working pattern?",
    [ "No; the evidence describes varied genders, settings and circumstances", "Yes, it consists only of women outdoors", "Yes, all work through managers", "No, but all work for the same reason" ], 0,
    "Research describes women, men and transgender people, working independently or through others, online, indoors and on street, with varied circumstances.", :home_office, 0, 1, "Heterogeneity is supporting context against one-size-fits-all assumptions." ],
  [ "What risk does Crown Prosecution Service guidance specifically recognise for people involved in prostitution?",
    [ "Automatic loss of legal personhood", "Targeting for assault and rape by controllers or customers", "Ineligibility to report any crime", "Mandatory imprisonment after victimisation" ], 1,
    "The guidance notes that sex workers are targeted for violence by people who believe they are unlikely to report or support a prosecution.", :cps, 1, 3, "Violence and barriers to justice are foundational outcomes in choosing a legal model." ],
  [ "What is the Crown Prosecution Service's stated approach to prosecuting people who sell sex?",
    [ "Prosecution must follow every police contact", "Imprisonment should replace support", "They should not be routinely prosecuted; diversion and support should be considered", "No offence can ever be prosecuted" ], 2,
    "Guidance prioritises non-prosecution, support and routes out unless prosecution is clearly required in the public interest.", :cps, 1, 2, "The gap between offences on the books and enforcement practice is significant to likely reform effects." ],
  [ "Can low-culpability participation in maintaining shared premises still satisfy a brothel offence even where prosecution may not be in the public interest?",
    [ "No, an offence and prosecution discretion are identical", "Only after a trafficking conviction", "Only if every worker is coerced", "Yes" ], 3,
    "CPS guidance distinguishes whether an offence is made out from whether prosecution is proportionate in a low-culpability case.", :cps, 1, 2, "Legal exposure can affect behaviour even without prosecution, making this distinction significant." ],
  [ "Which country decriminalised consensual adult prostitution through its Prostitution Reform Act 2003?",
    [ "New Zealand", "Sweden", "France", "Northern Ireland" ], 0,
    "New Zealand removed many sex-work-specific criminal penalties while retaining offences and regulation addressing coercion, under-age involvement and exploitation.", :nz_review, 1, 2, "A longstanding decriminalisation comparator is significant, though not automatically transferable." ],
  [ "What did New Zealand's statutory review conclude about the number of people selling sex after reform?",
    [ "It proved the number fell to zero", "It found no evidence of the predicted dramatic increase", "It showed every worker registered", "It could measure every transaction exactly" ], 1,
    "The review did not find evidence that decriminalisation caused the large expansion critics had predicted, while acknowledging measurement limitations.", :nz_review, 1, 3, "Whether reform expands the market is a foundational empirical concern." ],
  [ "Under New Zealand's reformed law, what legal right relevant to safety was made explicit for a sex worker?",
    [ "A right to compel any client to buy", "A right to avoid all workplace rules", "A right to refuse a client or sexual service", "A right to conceal trafficking evidence" ], 2,
    "The framework recognises that a sex worker may refuse a client or service, reinforcing that a commercial agreement does not remove continuing consent.", :nz_review, 1, 3, "Practical control over consent is a foundational claimed benefit of decriminalisation." ],
  [ "Did New Zealand's review find that decriminalisation eliminated violence and exploitation?",
    [ "Yes, immediately", "Yes, outside cities", "Only violence by strangers", "No" ], 3,
    "The review reported improvements and continuing problems; changing legal status did not remove violence, coercion or stigma.", :nz_review, -1, 3, "The persistence of serious harm is foundational to avoiding an overly simple policy claim." ],
  [ "What does the term 'Nordic model' usually criminalise while not criminalising the act of selling sex?",
    [ "Purchasing sexual services", "Providing sexual-health care", "Reporting exploitation", "Refusing a client" ], 0,
    "The model generally targets purchase and third-party activity while treating sellers as people to support rather than punish.", :committee, 0, 2, "Knowing the principal alternative is significant to comparing policy choices." ],
  [ "What did Northern Ireland's official three-year review report about the sex-purchase offence's effect on demand?",
    [ "Demand was proven to have ended", "The legislation had minimal effect on demand", "Demand could not exist online", "Every buyer was convicted" ], 1,
    "The commissioned research concluded that the offence had minimal effect on demand during the reviewed period.", :ni_review, 1, 3, "Observed performance of a nearby alternative model is foundational, with appropriate limits." ],
  [ "How many convictions for purchasing sex did Northern Ireland's review record from June 2015 to December 2018?",
    [ "None", "Fifteen", "Two", "More than one thousand" ], 2,
    "The review reported fifteen arrests and two convictions for purchasing sex during that period.", :ni_review, 0, 1, "The enforcement count is supporting context; it does not alone establish deterrence or welfare effects." ],
  [ "Could Northern Ireland's review determine that its purchase offence reduced trafficking?",
    [ "Yes, from advertising counts alone", "Yes, because two buyers were convicted", "Only for trafficking outside Europe", "No; it found no demand decrease from which to determine that effect" ], 3,
    "The review said the evidence did not establish reduced demand and therefore could not determine an effect on trafficking.", :ni_review, 1, 2, "Uncertain trafficking effects are significant because both sides make strong causal claims." ],
  [ "What did Northern Ireland's review say about reported fear and stigma among sex workers after the purchase ban?",
    [ "Heightened fear contributed to marginalisation and stigma", "Every respondent felt safer", "Stigma was no longer measurable", "Only buyers reported fear" ], 0,
    "Researchers could not attribute crime changes causally to the law, but reported heightened fear within a more marginalised and stigmatised climate.", :ni_review, 1, 2, "Worker interaction with law and police is a significant pathway through which policy may affect safety." ],
  [ "What legal direction has the World Health Organization recommended for adult sex work as part of HIV prevention?",
    [ "Mandatory imprisonment", "Decriminalisation and removal of punitive laws", "Criminalising possession of condoms", "Excluding sex workers from health services" ], 1,
    "WHO guidance recommends working toward decriminalisation alongside access to health, rights and protection from violence.", :who, 1, 3, "A major public-health body's evidence assessment is foundational to the health case, though policy involves other values." ],
  [ "Why can using condoms as evidence of prostitution undermine public health?",
    [ "Condoms prevent all evidence collection", "Condoms identify a person's occupation reliably", "It may deter carrying or negotiating condom use", "It makes laboratory testing impossible" ], 2,
    "Punitive use of condoms can make people less willing to carry them, conflicting with safer-sex interventions.", :who, 1, 2, "The incentive effect on protective behaviour is a significant mechanism, not merely a correlation." ],
  [ "Does evidence from New Zealand or Northern Ireland guarantee identical results in England and Wales?",
    [ "Yes, all legal systems are interchangeable", "Only health results transfer exactly", "Only arrest rates transfer exactly", "No" ], 3,
    "Law, enforcement, welfare, migration, market structure and baseline conditions differ; comparators inform but cannot determine UK outcomes.", :committee, 0, 1, "Transferability is a supporting methodological qualification." ],
  [ "After sex-work-specific offences were removed, could ordinary laws still address public nuisance, violence, employment breaches and unsafe premises?",
    [ "Yes", "No, all general law would cease", "Only if sex work were recriminalised", "Only through private contracts" ], 0,
    "Decriminalisation concerns offences specific to consensual adult sex work; generally applicable criminal, planning, employment and public-order laws can remain.", :committee, 1, 2, "The availability of general regulation is significant to whether decriminalisation means absence of control." ],
  [ "What central judgement remains after current law and comparative evidence are understood?",
    [ "Whether adults can legally consent to anything", "How autonomy, safety, exploitation, public order and enforceability should be weighed", "Whether trafficking exists", "Whether evidence can ever inform policy" ], 1,
    "Evidence can clarify mechanisms, outcomes and uncertainty, but cannot uniquely determine the acceptable balance between autonomy and protection from exploitation and harm.", :committee, 0, 1, "The synthesis marks the boundary between factual knowledge and the final normative judgement." ]
], SEX_WORK_SOURCES)

# Keep verbosity from identifying the answer; these remain plausible legal or empirical alternatives.
SEX_WORK_DECRIMINALISATION_FACTS.fetch(1)[:options][3] = "Only after a civil order has prohibited that person from soliciting in the specified locality"
SEX_WORK_DECRIMINALISATION_FACTS.fetch(2)[:options][0] = "Repeated online advertising directed at customers located within a particular local-authority area"
SEX_WORK_DECRIMINALISATION_FACTS.fetch(3)[:options][2] = "Only where a court has previously notified the buyer that the particular seller may be controlled"
SEX_WORK_DECRIMINALISATION_FACTS.fetch(4)[:options][3] = "Only where police had already supplied the buyer with information identifying the exploitative conduct"
SEX_WORK_DECRIMINALISATION_FACTS.fetch(5)[:options][3] = "Premises where a third party advertises appointments for several independent workers at different times"
SEX_WORK_DECRIMINALISATION_FACTS.fetch(6)[:options][0] = "Yes, because independent workers are exempt whenever each negotiates services and retains their own earnings"
SEX_WORK_DECRIMINALISATION_FACTS.fetch(8)[:options][3] = "A written agreement witnessed before any discussion of payment or of the services requested"
SEX_WORK_DECRIMINALISATION_FACTS.fetch(10)[:options][1] = "It can be derived by combining online advertisements with every prostitution-related police incident"
SEX_WORK_DECRIMINALISATION_FACTS.fetch(11)[:options][0] = "Only specialist print publications and premises already known to local licensing authorities"
SEX_WORK_DECRIMINALISATION_FACTS.fetch(12)[:options][1] = "Yes, official evidence treats women working indoors through third parties as the representative pattern"

# Eight foundational items retain the highest weight; the rest provide significant or supporting context.
[ 6, 8, 18, 19 ].each { |index| SEX_WORK_DECRIMINALISATION_FACTS.fetch(index)[:importance_weight] = 2 }
[ 16, 28 ].each { |index| SEX_WORK_DECRIMINALISATION_FACTS.fetch(index)[:importance_weight] = 1 }
