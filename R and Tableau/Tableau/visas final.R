library(tidyverse)

visas <- read.csv(file.choose())
str(visas)

table(visas$wage_offer_unit_of_pay_9089)
table(visas$case_status)

visas%>%
  group_by(class_of_admission) %>%
  summarise(number = n()) %>%
  arrange(desc(number)) %>%
  view()


visas %>%
  filter(class_of_admission == "H-1B") %>%
  pull(case_status) %>%
  table %>%
  prop.table()

table(visas$country_of_citizenship)
table(visas$decision_year)

summary(parse_number(visas$wage_offer_from_9089))