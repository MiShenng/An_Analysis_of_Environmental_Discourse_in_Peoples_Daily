# Overview

This repository contains code and materials for a research project on environmental discourse in People’s Daily across print and social media.

This project examines how environmental issues have been represented in Chinese mainstream media over time. Using People’s Daily as a representative case, the study constructs a dataset of environmental news coverage from 1949 to the present and analyzes the historical development of environmental discourse in relation to changes in China’s environmental protection policies.

The project also compares environmental discourse in the print editions of People’s Daily with related posts published on its Weibo account, in order to examine how environmental communication changes across media platforms.

## Research Focus

The project focuses on three main questions:

1. How has environmental discourse in People’s Daily changed across different historical periods?
2. How do these changes correspond to the evolution of China’s environmental protection policies?
3. How does environmental discourse differ between the newspaper’s print editions and its Weibo posts?

## Data

The project uses two sources of data:

- Environmental news coverage from People’s Daily print editions, from 1949 to the present.
- Weibo posts related to environmental protection published by People’s Daily.

Due to copyright restrictions and platform policies, raw news articles and social media posts are not publicly released in this repository.

## Method

The project combines computational content analysis with discourse analysis.

First, a dataset of environmental news coverage was constructed from People’s Daily. An LLM-driven automated content analysis program was then developed to assist with coding and classification. Based on the coding results, the project applied Fairclough’s discourse analysis approach to examine how environmental discourse changed across historical periods.

The analysis was further combined with the evolution of China’s environmental protection policies, allowing the project to identify broad phases in the historical development of environmental discourse.

For the social media component, a self-built web crawler was used to collect Weibo posts related to environmental protection from People’s Daily. These posts were then compared with content from the newspaper’s print editions.

## Repository Structure

├── README.md
├── data/
│   └── processed/
├── scripts/
│   ├── crawler/
│   ├── content_analysis/
│   └── discourse_analysis/
├── results/
│   ├── tables/
│   └── figures/
└── docs/

## Notes

This repository is intended for academic documentation and methodological transparency. Raw copyrighted news content and platform data are not included.

## Project Information

Project: A Study on Discourse Construction and Visual Narrative Strategies in the New Mainstream Media Environment of the Converged Media Era  
Role: Research Assistant  
Principal Investigator: Xinxin Li, Lanzhou University    
Funding: Basic Research Projects of Central Universities in China
