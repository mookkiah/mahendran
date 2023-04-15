---
layout: post
title: "Excel Tips and Tricks for newbie"
date: 2023-04-06 11:35:00 -0400
modified_date: 2023-04-15 06:30:00 -0400
categories: microsoft excel
---

# Excel Tips and Trick for newbie

## Count rows after filtering

- Use `SUBTOTAL` function
- Example: `=SUBTOTAL(103,A:A)`
- where `103` represents `COUNTA` function which counts non empty cells (in the range)
- Refer - https://support.microsoft.com/en-us/office/subtotal-function-7b027003-f060-4ade-9040-e478765b9939

### Sample Use Case

I had an excel sheet with 200k rows. I want to count the rows as I apply differnt filters. I thought, it would show on the status bar.
Using `SUBTOTAL` function, we can count the rows which has non empty values. By doing this I was able to keep adjust my filters and got the count insights.

## Find if the given value present in another set(range) of values.

- Use `VLOOKUP` function
- Example: `VLOOKUP(A1017,Sheet1!A:A,1,FALSE)`
- Refer - https://support.microsoft.com/en-us/office/vlookup-function-0bbc8083-26fe-4963-8ab8-93a18ad188a1
- Venn Diagram understanding - https://www.britannica.com/topic/Venn-diagram

### Sample Use Case

I received 2 source of excel sheet and required to find the gap.

- Source 1 (S1) has whole set.
- Source 2 (S2) has part
  Goal is to find the rows in S1 which are not in S2.
  Both source has different structure but have a common column to map.

#### Steps:

- Copied the key (common value column) column from S2 in to another sheet of S1.
- Inserted another column in S1 data sheet.
- used `VLOOKUP` formula `=NOT(ISERROR(VLOOKUP(A1017,Sheet1!A:A,1,FALSE)))`
- `VLOOKUP` returns a value if present or error out
- `ISERROR` used to translate the ERROR into a boolean to represent FOUND or NOT FOUND
- `NOT` used to make the data meaningful for the column heading. Ex: "Is found in S2?"

## Find duplicate entries

- Use `Home` --> `Conditional Formatting` --> `Highlight Cells Rules` --> `Duplicate Values` --> apply color on duplicate values
- Use `Filter` column header and filter it `By Color`.
