GUN_CONTROL_FACTS = [
  {
    prompt: "Under current federal law, who must initiate a NICS background check before transferring a firearm to an unlicensed buyer?",
    options: ["Every private seller", "A federally licensed firearms dealer", "Only a police department"],
    correct_option: 1,
    explanation: "Federal firearms licensees must use NICS for prospective unlicensed buyers; occasional private sellers are generally not subject to that federal requirement.",
    source_name: "Congressional Research Service",
    source_url: "https://www.congress.gov/crs-product/R48445",
    evidence_direction: 1
  },
  {
    prompt: "Does current federal law generally require a background check for an occasional, same-state sale between two unlicensed private individuals?",
    options: ["Yes, in every state", "No, although state law may require one", "Only if the firearm is a rifle"],
    correct_option: 1,
    explanation: "Federal law generally leaves occasional intrastate transfers between unlicensed people outside NICS, while some states impose broader rules.",
    source_name: "Congressional Research Service",
    source_url: "https://www.congress.gov/crs-product/IF11038",
    evidence_direction: 1
  },
  {
    prompt: "Does buying from a licensed dealer at a gun show avoid the federal background-check requirement?",
    options: ["Yes", "No", "Only on weekends"],
    correct_option: 1,
    explanation: "A licensed dealer must conduct the same required check regardless of whether the sale occurs in a shop or at a gun show.",
    source_name: "Congressional Research Service",
    source_url: "https://www.congress.gov/crs-product/R48445",
    evidence_direction: 0
  },
  {
    prompt: "What is the primary purpose of the National Instant Criminal Background Check System (NICS)?",
    options: ["To register every firearm", "To verify whether a buyer is legally eligible", "To set firearm prices"],
    correct_option: 1,
    explanation: "NICS checks available records to determine whether federal or state law prohibits the prospective buyer.",
    source_name: "Federal Bureau of Investigation",
    source_url: "https://www.fbi.gov/how-we-can-help-you/more-fbi-services-and-information/nics/about-nics",
    evidence_direction: 0
  },
  {
    prompt: "Which result can NICS give when more research is needed before deciding eligibility?",
    options: ["Delayed", "Licensed", "Registered"],
    correct_option: 0,
    explanation: "NICS may return proceed, denied or delayed; a delay allows examiners to research potentially matching records.",
    source_name: "Federal Bureau of Investigation",
    source_url: "https://www.fbi.gov/how-we-can-help-you/more-fbi-services-and-information/nics/about-nics",
    evidence_direction: 0
  },
  {
    prompt: "If NICS has not issued a final decision after three business days, what may a licensed dealer generally do under federal law?",
    options: ["Transfer at the dealer's discretion if state law allows", "Never transfer the firearm", "Automatically destroy the firearm"],
    correct_option: 0,
    explanation: "Federal law permits, but does not require, the dealer to proceed after three business days without a final determination, subject to state law.",
    source_name: "Federal Bureau of Investigation",
    source_url: "https://www.fbi.gov/how-we-can-help-you/more-fbi-services-and-information/nics/about-nics",
    evidence_direction: 1
  },
  {
    prompt: "Can a person who believes a NICS denial is mistaken challenge it?",
    options: ["Yes", "No", "Only through Congress"],
    correct_option: 0,
    explanation: "The FBI provides a process to request the reason for a denial and submit a challenge.",
    source_name: "Federal Bureau of Investigation",
    source_url: "https://www.fbi.gov/how-we-can-help-you/more-fbi-services-and-information/nics/requesting-reason-for-andor-challenging-a-nics-related-denial",
    evidence_direction: -1
  },
  {
    prompt: "Are NICS checks based on fingerprint comparison?",
    options: ["Always", "No; routine checks compare biographical information with records", "Only for private sales"],
    correct_option: 1,
    explanation: "Routine NICS checks use identifying biographical information rather than fingerprints, which is one reason a challenge process is necessary.",
    source_name: "Federal Bureau of Investigation",
    source_url: "https://www.fbi.gov/how-we-can-help-you/more-fbi-services-and-information/nics/requesting-reason-for-andor-challenging-a-nics-related-denial",
    evidence_direction: -1
  },
  {
    prompt: "Approximately how many NICS background checks were processed in 2022?",
    options: ["About 3 million", "About 31.6 million", "About 316 million"],
    correct_option: 1,
    explanation: "The FBI's 2022 operational report records 31,596,646 checks processed by the FBI and state users.",
    source_name: "FBI NICS 2022 Operational Report",
    source_url: "https://www.fbi.gov/file-repository/nics-2022-operations-report.pdf",
    evidence_direction: 0
  },
  {
    prompt: "Do NICS check totals equal the number of firearms sold?",
    options: ["Yes, exactly one check always equals one gun", "No", "Only for handguns"],
    correct_option: 1,
    explanation: "A check can cover more than one firearm, and checks also occur for permits and other purposes, so totals are not sales counts.",
    source_name: "Federal Bureau of Investigation",
    source_url: "https://www.fbi.gov/file-repository/nics_firearm_checks_-_month_year.pdf",
    evidence_direction: -1
  },
  {
    prompt: "How many transactions did the FBI component of NICS deny in 2022?",
    options: ["About 1,300", "About 132,000", "About 13 million"],
    correct_option: 1,
    explanation: "The FBI reported 131,865 denials among the transactions it processed in 2022.",
    source_name: "FBI NICS 2022 Operational Report",
    source_url: "https://www.fbi.gov/file-repository/nics-2022-operations-report.pdf",
    evidence_direction: 1
  },
  {
    prompt: "What share of FBI-processed NICS checks received an immediate determination in 2022?",
    options: ["About 9%", "About 51%", "About 91%"],
    correct_option: 2,
    explanation: "The FBI reported an immediate determination rate of 91.36%.",
    source_name: "FBI NICS 2022 Operational Report",
    source_url: "https://www.fbi.gov/file-repository/nics-2022-operations-report.pdf",
    evidence_direction: -1
  },
  {
    prompt: "Which is a federal category generally prohibited from possessing firearms?",
    options: ["People convicted of a felony-level offense", "All people over age 65", "People without a driving licence"],
    correct_option: 0,
    explanation: "Federal law lists nine broad prohibited categories, including people convicted of crimes punishable by more than one year.",
    source_name: "Congressional Research Service",
    source_url: "https://www.congress.gov/crs-product/R48445",
    evidence_direction: 1
  },
  {
    prompt: "Does federal firearm prohibition apply to some people convicted of misdemeanor domestic violence?",
    options: ["Yes", "No", "Only if the offence involved property"],
    correct_option: 0,
    explanation: "A qualifying misdemeanor crime of domestic violence is one of the federal prohibited categories.",
    source_name: "Congressional Research Service",
    source_url: "https://www.congress.gov/crs-product/R48445",
    evidence_direction: 1
  },
  {
    prompt: "What is a straw purchase?",
    options: ["A lawful gift disclosed to a dealer", "Buying a firearm for another person while falsely claiming to be the actual buyer", "Buying ammunition in bulk"],
    correct_option: 1,
    explanation: "A straw purchaser conceals the true acquirer, allowing that person—including a prohibited person—to bypass the normal check.",
    source_name: "Congressional Research Service",
    source_url: "https://www.congress.gov/crs-product/R48445",
    evidence_direction: -1
  },
  {
    prompt: "Can a background check on the named buyer alone prevent every straw purchase?",
    options: ["Yes", "No", "Only for rifles"],
    correct_option: 1,
    explanation: "A buyer with a clean record can pass a check while illegally purchasing for someone else; checks therefore cannot eliminate this diversion route by themselves.",
    source_name: "Congressional Research Service",
    source_url: "https://www.congress.gov/crs-product/R48445",
    evidence_direction: -1
  },
  {
    prompt: "In the 2016 federal survey of state and federal prisoners who possessed a gun during their offence, where did most obtain it?",
    options: ["From a retail gun store", "From the underground market or family and friends", "Directly from the military"],
    correct_option: 1,
    explanation: "The Bureau of Justice Statistics found most obtained the firearm through theft, an underground source, or family and friends rather than a retail source.",
    source_name: "Bureau of Justice Statistics",
    source_url: "https://bjs.ojp.gov/content/pub/pdf/suficspi16st.pdf",
    evidence_direction: -1
  },
  {
    prompt: "In that 2016 prisoner survey, approximately what share obtained the firearm from a retail source?",
    options: ["About 1.3%", "About 10.1%", "About 75%"],
    correct_option: 1,
    explanation: "About 10.1% reported a retail source; only 1.3% obtained it from a retail source under their own name.",
    source_name: "Bureau of Justice Statistics",
    source_url: "https://bjs.ojp.gov/content/pub/pdf/suficspi16st.pdf",
    evidence_direction: -1
  },
  {
    prompt: "In that 2016 prisoner survey, approximately what share obtained the firearm at a gun show?",
    options: ["0.8%", "18%", "48%"],
    correct_option: 0,
    explanation: "The survey estimated 0.8% obtained the firearm at a gun show; this does not measure all private transfers.",
    source_name: "Bureau of Justice Statistics",
    source_url: "https://bjs.ojp.gov/content/pub/pdf/suficspi16st.pdf",
    evidence_direction: -1
  },
  {
    prompt: "What was the most common trafficking channel in ATF investigations covering 2017–2021?",
    options: ["Unlicensed dealers", "Foreign military sales", "Antique auctions"],
    correct_option: 0,
    explanation: "ATF identified trafficking by unlicensed dealers as the most common channel among the investigations it analysed.",
    source_name: "ATF National Firearms Commerce and Trafficking Assessment",
    source_url: "https://www.atf.gov/firearms/national-firearms-commerce-and-trafficking-assessment-nfcta-firearms-trafficking-investigations-volume-three",
    evidence_direction: 1
  },
  {
    prompt: "Are ATF-traced crime guns a random sample of every gun used in crime?",
    options: ["Yes", "No", "Only in large cities"],
    correct_option: 1,
    explanation: "ATF cautions that trace data are investigative records, not a representative random sample of all crime guns.",
    source_name: "ATF National Firearms Commerce and Trafficking Assessment",
    source_url: "https://www.atf.gov/firearms/national-firearms-commerce-and-trafficking-assessment-nfcta-firearms-trafficking-investigations-volume-three",
    evidence_direction: -1
  },
  {
    prompt: "What does an ATF firearm trace usually seek to identify?",
    options: ["The first retail purchaser in the distribution chain", "Every person who ever handled the gun", "The gun's ballistic accuracy"],
    correct_option: 0,
    explanation: "A trace follows a firearm from manufacture or import through wholesale and retail records to the first unlicensed purchaser.",
    source_name: "Bureau of Alcohol, Tobacco, Firearms and Explosives",
    source_url: "https://www.atf.gov/firearms/tools-services-law-enforcement/national-tracing-center",
    evidence_direction: 0
  },
  {
    prompt: "Why can records created during checked firearm transfers assist later investigations?",
    options: ["They can help trace a recovered gun's distribution path", "They predict who will commit a crime", "They replace ballistic evidence"],
    correct_option: 0,
    explanation: "Dealer records support ATF traces that can produce leads and reveal trafficking patterns; they do not predict individual conduct.",
    source_name: "Bureau of Alcohol, Tobacco, Firearms and Explosives",
    source_url: "https://www.atf.gov/resource-center/fact-sheet/etrace-internet-based-firearms-tracing-and-analysis",
    evidence_direction: 1
  },
  {
    prompt: "How many firearm-related deaths occurred in the United States in 2022?",
    options: ["Fewer than 5,000", "More than 48,000", "More than 480,000"],
    correct_option: 1,
    explanation: "CDC mortality data recorded more than 48,000 firearm-related deaths in 2022.",
    source_name: "Centers for Disease Control and Prevention",
    source_url: "https://www.cdc.gov/firearm-violence/data-research/facts-stats/",
    evidence_direction: 1
  },
  {
    prompt: "Which accounted for the largest share of U.S. firearm deaths in 2022?",
    options: ["Suicide", "Homicide", "Unintentional injury"],
    correct_option: 0,
    explanation: "More than half were suicides, while more than four in ten were homicides.",
    source_name: "Centers for Disease Control and Prevention",
    source_url: "https://www.cdc.gov/firearm-violence/data-research/facts-stats/",
    evidence_direction: 1
  },
  {
    prompt: "How lethal are firearm suicide attempts compared with many other methods?",
    options: ["Most are nonfatal", "Most are fatal", "No data exist"],
    correct_option: 1,
    explanation: "CDC notes that most people who use a firearm in a suicide attempt die from the injury.",
    source_name: "Centers for Disease Control and Prevention",
    source_url: "https://www.cdc.gov/firearm-violence/data-research/facts-stats/",
    evidence_direction: 1
  },
  {
    prompt: "In 2022, firearm injuries were the leading cause of death for which U.S. age group?",
    options: ["Children and teens ages 1–19", "Adults ages 45–64", "Adults over 80"],
    correct_option: 0,
    explanation: "CDC reports firearm injuries were the leading cause of death among people ages 1–19 in 2022.",
    source_name: "Centers for Disease Control and Prevention",
    source_url: "https://www.cdc.gov/firearm-violence/data-research/facts-stats/",
    evidence_direction: 1
  },
  {
    prompt: "Did the 2022 Bipartisan Safer Communities Act add enhanced checks for firearm buyers under 21?",
    options: ["Yes", "No", "Only for hunting licences"],
    correct_option: 0,
    explanation: "The law requires NICS to seek additional juvenile justice and mental-health records for buyers aged 18–20.",
    source_name: "Congressional Research Service",
    source_url: "https://www.congress.gov/crs-product/R47310",
    evidence_direction: 1
  },
  {
    prompt: "After the enhanced under-21 checks began, did the FBI report denials based solely on information obtained through that added process?",
    options: ["Yes, more than 600 in the first 200,000-plus checks", "No", "The FBI does not process these checks"],
    correct_option: 0,
    explanation: "The FBI reported more than 600 such denials among over 200,000 enhanced checks in the program's early period.",
    source_name: "Federal Bureau of Investigation",
    source_url: "https://www.fbi.gov/news/stories/nics-enhanced-background-checks-for-under-21-gun-buyers-showing-results",
    evidence_direction: 1
  },
  {
    prompt: "Did the U.S. Supreme Court's Heller decision describe the Second Amendment right as unlimited?",
    options: ["Yes", "No", "The decision did not concern the Second Amendment"],
    correct_option: 1,
    explanation: "Heller recognized an individual right while stating it is not unlimited and identifying longstanding restrictions it did not cast doubt upon.",
    source_name: "Supreme Court of the United States",
    source_url: "https://www.supremecourt.gov/opinions/07pdf/07-290.pdf",
    evidence_direction: 0
  }
].freeze
