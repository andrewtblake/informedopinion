GUN_CONTROL_FACTS = [
  {
    prompt: "Which seller is required by federal law to initiate a NICS check before transferring a firearm to an unlicensed customer?",
    options: [ "A federally licensed firearms dealer", "Any person selling a firearm inherited from a relative", "An occasional private seller making a same-state sale", "A private collector trading two firearms" ],
    correct_option: 0,
    explanation: "Federal firearms licensees must use NICS for prospective unlicensed buyers; occasional private sellers are generally not subject to that federal requirement.",
    source_name: "Congressional Research Service",
    source_url: "https://www.congress.gov/crs-product/R48445",
    evidence_direction: 1
  },
  {
    prompt: "Under federal law alone, what normally applies to an occasional firearm sale between two unlicensed residents of the same state?",
    options: [ "The buyer must request a NICS check directly", "No federal background check is generally required, though state law may require one", "The seller must obtain a temporary federal licence", "The transfer is federally prohibited" ],
    correct_option: 1,
    explanation: "Federal law generally leaves occasional intrastate transfers between unlicensed people outside NICS, while some states impose broader rules.",
    source_name: "Congressional Research Service",
    source_url: "https://www.congress.gov/crs-product/IF11038",
    evidence_direction: 1
  },
  {
    prompt: "A licensed dealer sells a firearm from a table at a gun show. Which federal background-check rule applies?",
    options: [ "A check is optional because the sale is away from the dealer's shop", "A check is required only for a handgun", "The same check required for the dealer's shop sale is required", "The gun-show organiser performs one check covering every sale" ],
    correct_option: 2,
    explanation: "A licensed dealer must conduct the same required check regardless of whether the sale occurs in a shop or at a gun show.",
    source_name: "Congressional Research Service",
    source_url: "https://www.congress.gov/crs-product/R48445",
    evidence_direction: 0
  },
  {
    prompt: "What question is the National Instant Criminal Background Check System designed to answer for a firearm transfer?",
    options: [ "Whether the firearm has previously been registered", "Whether the buyer has completed safety training", "Whether the firearm's price is correctly reported", "Whether available records show the buyer is legally prohibited" ],
    correct_option: 3,
    explanation: "NICS checks available records to determine whether federal or state law prohibits the prospective buyer.",
    source_name: "Federal Bureau of Investigation",
    source_url: "https://www.fbi.gov/how-we-can-help-you/more-fbi-services-and-information/nics/about-nics",
    evidence_direction: 0
  },
  {
    prompt: "Which NICS response tells a dealer that examiners need more time to research a potentially matching record?",
    options: [ "Delayed", "Conditional", "Pending licence", "Referral" ],
    correct_option: 0,
    explanation: "NICS may return proceed, denied or delayed; a delay allows examiners to research potentially matching records.",
    source_name: "Federal Bureau of Investigation",
    source_url: "https://www.fbi.gov/how-we-can-help-you/more-fbi-services-and-information/nics/about-nics",
    evidence_direction: 0
  },
  {
    prompt: "If NICS has not reached a final determination after three business days, what does federal law generally permit a licensed dealer to do?",
    options: [ "Treat the transaction as permanently denied", "Use the dealer's discretion to transfer if state law permits", "Require the FBI to approve the sale automatically", "Transfer only a long gun, not a handgun" ],
    correct_option: 1,
    explanation: "Federal law permits, but does not require, the dealer to proceed after three business days without a final determination, subject to state law.",
    source_name: "Federal Bureau of Investigation",
    source_url: "https://www.fbi.gov/how-we-can-help-you/more-fbi-services-and-information/nics/about-nics",
    evidence_direction: 1
  },
  {
    prompt: "What recourse does the FBI offer a prospective buyer who believes a NICS denial resulted from a mistaken identity or record?",
    options: [ "Apply for a new Social Security number", "Ask the firearm dealer to overrule NICS", "Request the reason and submit a challenge", "Wait one year and repeat the same transaction" ],
    correct_option: 2,
    explanation: "The FBI provides a process to request the reason for a denial and submit a challenge.",
    source_name: "Federal Bureau of Investigation",
    source_url: "https://www.fbi.gov/how-we-can-help-you/more-fbi-services-and-information/nics/requesting-reason-for-andor-challenging-a-nics-related-denial",
    evidence_direction: -1
  },
  {
    prompt: "What identifying information does a routine NICS check principally compare with government records?",
    options: [ "A DNA profile", "A fingerprint image taken by the dealer", "A firearm-owner registration number", "Biographical details such as name and date of birth" ],
    correct_option: 3,
    explanation: "Routine NICS checks use identifying biographical information rather than fingerprints, which is one reason a challenge process is necessary.",
    source_name: "Federal Bureau of Investigation",
    source_url: "https://www.fbi.gov/how-we-can-help-you/more-fbi-services-and-information/nics/requesting-reason-for-andor-challenging-a-nics-related-denial",
    evidence_direction: -1
  },
  {
    prompt: "How many NICS background-check transactions did the FBI and state users process during 2022?",
    options: [ "Approximately 31.6 million", "Approximately 19.4 million", "Approximately 54.8 million", "Approximately 8.2 million" ],
    correct_option: 0,
    explanation: "The FBI's 2022 operational report records 31,596,646 checks processed by the FBI and state users.",
    source_name: "FBI NICS 2022 Operational Report",
    source_url: "https://www.fbi.gov/file-repository/nics-2022-operations-report.pdf",
    evidence_direction: 0
  },
  {
    prompt: "Why should published NICS transaction totals not be read as firearm-sales totals?",
    options: [ "NICS excludes every handgun transaction", "One check can cover multiple firearms and checks also serve non-sale purposes", "State-run checks are counted as two transactions", "NICS reports only denied transactions" ],
    correct_option: 1,
    explanation: "A check can cover more than one firearm, and checks also occur for permits and other purposes, so totals are not sales counts.",
    source_name: "Federal Bureau of Investigation",
    source_url: "https://www.fbi.gov/file-repository/nics_firearm_checks_-_month_year.pdf",
    evidence_direction: -1
  },
  {
    prompt: "How many firearm transactions did the FBI-operated part of NICS deny in 2022?",
    options: [ "208,430", "54,612", "131,865", "17,572" ],
    correct_option: 2,
    explanation: "The FBI reported 131,865 denials among the transactions it processed in 2022.",
    source_name: "FBI NICS 2022 Operational Report",
    source_url: "https://www.fbi.gov/file-repository/nics-2022-operations-report.pdf",
    evidence_direction: 1
  },
  {
    prompt: "What immediate-determination rate did the FBI component of NICS report for 2022?",
    options: [ "76.04%", "98.92%", "84.50%", "91.36%" ],
    correct_option: 3,
    explanation: "The FBI reported an immediate determination rate of 91.36%.",
    source_name: "FBI NICS 2022 Operational Report",
    source_url: "https://www.fbi.gov/file-repository/nics-2022-operations-report.pdf",
    evidence_direction: -1
  },
  {
    prompt: "Which criminal-history circumstance is one of the federal categories generally barring firearm possession?",
    options: [ "Conviction for a crime punishable by more than one year", "Any arrest that did not lead to prosecution", "A civil parking fine left unpaid", "A juvenile curfew warning" ],
    correct_option: 0,
    explanation: "Federal law lists nine broad prohibited categories, including people convicted of crimes punishable by more than one year.",
    source_name: "Congressional Research Service",
    source_url: "https://www.congress.gov/crs-product/R48445",
    evidence_direction: 1
  },
  {
    prompt: "Which domestic-violence record can create a federal firearm prohibition?",
    options: [ "Any police call involving a domestic disagreement", "A qualifying misdemeanor domestic-violence conviction", "A divorce petition with no allegation of violence", "A voluntarily requested counselling appointment" ],
    correct_option: 1,
    explanation: "A qualifying misdemeanor crime of domestic violence is one of the federal prohibited categories.",
    source_name: "Congressional Research Service",
    source_url: "https://www.congress.gov/crs-product/R48445",
    evidence_direction: 1
  },
  {
    prompt: "Which transaction is a straw purchase?",
    options: [ "A parent openly buys a lawful gift for an eligible adult child", "A collector buys a firearm and later decides to sell it", "A person falsely claims to be the actual buyer while purchasing for someone else", "A buyer pays a licensed dealer in cash" ],
    correct_option: 2,
    explanation: "A straw purchaser conceals the true acquirer, allowing that person—including a prohibited person—to bypass the normal check.",
    source_name: "Congressional Research Service",
    source_url: "https://www.congress.gov/crs-product/R48445",
    evidence_direction: -1
  },
  {
    prompt: "Why can a check of the person standing at the dealer's counter fail to stop a straw purchase?",
    options: [ "NICS cannot check felony convictions", "Dealers are prohibited from checking identification", "NICS applies only after the firearm is transferred", "An eligible purchaser may conceal that the firearm is really for someone else" ],
    correct_option: 3,
    explanation: "A buyer with a clean record can pass a check while illegally purchasing for someone else; checks therefore cannot eliminate this diversion route by themselves.",
    source_name: "Congressional Research Service",
    source_url: "https://www.congress.gov/crs-product/R48445",
    evidence_direction: -1
  },
  {
    prompt: "In the 2016 federal prisoner survey, which source category accounted for most firearms possessed during the offence?",
    options: [ "The underground market or family and friends", "A licensed retail gun store", "A gun show or auction", "A government surplus programme" ],
    correct_option: 0,
    explanation: "The Bureau of Justice Statistics found most obtained the firearm through theft, an underground source, or family and friends rather than a retail source.",
    source_name: "Bureau of Justice Statistics",
    source_url: "https://bjs.ojp.gov/content/pub/pdf/suficspi16st.pdf",
    evidence_direction: -1
  },
  {
    prompt: "What proportion of prisoners who possessed a firearm during their offence reported obtaining it from a retail source?",
    options: [ "21.7%", "10.1%", "3.4%", "38.9%" ],
    correct_option: 1,
    explanation: "About 10.1% reported a retail source; only 1.3% obtained it from a retail source under their own name.",
    source_name: "Bureau of Justice Statistics",
    source_url: "https://bjs.ojp.gov/content/pub/pdf/suficspi16st.pdf",
    evidence_direction: -1
  },
  {
    prompt: "In that prisoner survey, what proportion reported obtaining the firearm at a gun show?",
    options: [ "6.2%", "2.9%", "0.8%", "14.4%" ],
    correct_option: 2,
    explanation: "The survey estimated 0.8% obtained the firearm at a gun show; this does not measure all private transfers.",
    source_name: "Bureau of Justice Statistics",
    source_url: "https://bjs.ojp.gov/content/pub/pdf/suficspi16st.pdf",
    evidence_direction: -1
  },
  {
    prompt: "Among ATF trafficking investigations covering 2017–2021, which channel appeared most often?",
    options: [ "Theft from private owners", "Straw-purchasing rings", "Theft from licensed dealers", "Trafficking by unlicensed dealers" ],
    correct_option: 3,
    explanation: "ATF identified trafficking by unlicensed dealers as the most common channel among the investigations it analysed.",
    source_name: "ATF National Firearms Commerce and Trafficking Assessment",
    source_url: "https://www.atf.gov/firearms/national-firearms-commerce-and-trafficking-assessment-nfcta-firearms-trafficking-investigations-volume-three",
    evidence_direction: 1
  },
  {
    prompt: "What limitation does ATF state about crime-gun trace data?",
    options: [ "Traced firearms are not a random sample representative of all crime guns", "Trace records omit the firearm manufacturer", "Only firearms recovered outside the United States are traced", "Every traced firearm is proven to have been fired in a crime" ],
    correct_option: 0,
    explanation: "ATF cautions that trace data are investigative records, not a representative random sample of all crime guns.",
    source_name: "ATF National Firearms Commerce and Trafficking Assessment",
    source_url: "https://www.atf.gov/firearms/national-firearms-commerce-and-trafficking-assessment-nfcta-firearms-trafficking-investigations-volume-three",
    evidence_direction: -1
  },
  {
    prompt: "What endpoint does an ATF firearm trace ordinarily seek in the commercial distribution chain?",
    options: [ "The most recent person found possessing the firearm", "The first unlicensed retail purchaser", "Every owner in chronological order", "The first law-enforcement agency to recover it" ],
    correct_option: 1,
    explanation: "A trace follows a firearm from manufacture or import through wholesale and retail records to the first unlicensed purchaser.",
    source_name: "Bureau of Alcohol, Tobacco, Firearms and Explosives",
    source_url: "https://www.atf.gov/firearms/tools-services-law-enforcement/national-tracing-center",
    evidence_direction: 0
  },
  {
    prompt: "How can records made during a checked dealer transfer assist a later criminal investigation?",
    options: [ "They establish that the original purchaser committed the crime", "They identify the firearm's ballistic signature", "They help trace distribution and identify investigative leads", "They reveal every later private transfer automatically" ],
    correct_option: 2,
    explanation: "Dealer records support ATF traces that can produce leads and reveal trafficking patterns; they do not predict individual conduct.",
    source_name: "Bureau of Alcohol, Tobacco, Firearms and Explosives",
    source_url: "https://www.atf.gov/resource-center/fact-sheet/etrace-internet-based-firearms-tracing-and-analysis",
    evidence_direction: 1
  },
  {
    prompt: "Approximately how many firearm-related deaths did CDC mortality data record in the United States in 2022?",
    options: [ "26,000", "71,000", "35,000", "More than 48,000" ],
    correct_option: 3,
    explanation: "CDC mortality data recorded more than 48,000 firearm-related deaths in 2022.",
    source_name: "Centers for Disease Control and Prevention",
    source_url: "https://www.cdc.gov/firearm-violence/data-research/facts-stats/",
    evidence_direction: 1
  },
  {
    prompt: "Which intent category accounted for the largest share of U.S. firearm deaths in 2022?",
    options: [ "Suicide", "Homicide", "Unintentional injury", "Legal intervention" ],
    correct_option: 0,
    explanation: "More than half were suicides, while more than four in ten were homicides.",
    source_name: "Centers for Disease Control and Prevention",
    source_url: "https://www.cdc.gov/firearm-violence/data-research/facts-stats/",
    evidence_direction: 1
  },
  {
    prompt: "What does CDC report about the outcome of suicide attempts involving a firearm?",
    options: [ "Their fatality rate is similar to poisoning attempts", "Most result in death", "Most result in discharge without hospital admission", "Outcome data are unavailable nationally" ],
    correct_option: 1,
    explanation: "CDC notes that most people who use a firearm in a suicide attempt die from the injury.",
    source_name: "Centers for Disease Control and Prevention",
    source_url: "https://www.cdc.gov/firearm-violence/data-research/facts-stats/",
    evidence_direction: 1
  },
  {
    prompt: "For which U.S. age group were firearm injuries the leading cause of death in 2022?",
    options: [ "Adults aged 20–34", "Infants under age one", "Children and teenagers aged 1–19", "Adults aged 65–79" ],
    correct_option: 2,
    explanation: "CDC reports firearm injuries were the leading cause of death among people ages 1–19 in 2022.",
    source_name: "Centers for Disease Control and Prevention",
    source_url: "https://www.cdc.gov/firearm-violence/data-research/facts-stats/",
    evidence_direction: 1
  },
  {
    prompt: "What additional background-check process did the 2022 Bipartisan Safer Communities Act establish for buyers aged 18–20?",
    options: [ "A federal firearm-training examination", "Fingerprint comparison for every transaction", "Approval from the buyer's school district", "A search for potentially disqualifying juvenile records" ],
    correct_option: 3,
    explanation: "The law requires NICS to seek additional juvenile justice and mental-health records for buyers aged 18–20.",
    source_name: "Congressional Research Service",
    source_url: "https://www.congress.gov/crs-product/R47310",
    evidence_direction: 1
  },
  {
    prompt: "What early result did the FBI report from its first 200,000-plus enhanced checks of buyers under 21?",
    options: [ "More than 600 denials based solely on newly obtained information", "No additional denials beyond a traditional check", "Approximately 12,000 automatic denials", "Fewer than 50 agencies responded to record requests" ],
    correct_option: 0,
    explanation: "The FBI reported more than 600 such denials among over 200,000 enhanced checks in the program's early period.",
    source_name: "Federal Bureau of Investigation",
    source_url: "https://www.fbi.gov/news/stories/nics-enhanced-background-checks-for-under-21-gun-buyers-showing-results",
    evidence_direction: 1
  },
  {
    prompt: "How did the Supreme Court describe the scope of the individual Second Amendment right recognised in District of Columbia v. Heller?",
    options: [ "It prevents every condition on a firearm transfer", "It is an individual right but is not unlimited", "It applies only while serving in a state militia", "It bars states from regulating commercial firearm sales" ],
    correct_option: 1,
    explanation: "Heller recognised an individual right while stating it is not unlimited and identifying longstanding restrictions it did not cast doubt upon.",
    source_name: "Supreme Court of the United States",
    source_url: "https://www.supremecourt.gov/opinions/07pdf/07-290.pdf",
    evidence_direction: 0
  }
].freeze
