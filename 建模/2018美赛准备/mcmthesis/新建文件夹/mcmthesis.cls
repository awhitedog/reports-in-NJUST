%%
%% This is file `mcmthesis.cls',
%% generated with the docstrip utility.
%%
%% The original source files were:
%%
%% mcmthesis.dtx  (with options: `class')
%% 
%% -----------------------------------
%% 
%% This is a generated file.
%% 
%% Copyright (C)
%%     2010 -- 2015 by Zhaoli Wang
%%     2014 -- 2015 by Liam Huang
%% 
%% This work may be distributed and/or modified under the
%% conditions of the LaTeX Project Public License, either version 1.3
%% of this license or (at your option) any later version.
%% The latest version of this license is in
%%   http://www.latex-project.org/lppl.txt
%% and version 1.3 or later is part of all distributions of LaTeX
%% version 2005/12/01 or later.
%% 
%% This work has the LPPL maintenance status `maintained'.
%% 
%% The Current Maintainer of this work is Liam Huang.
%% 
\NeedsTeXFormat{LaTeX2e}[1999/12/01]
\ProvidesClass{mcmthesis}
  [2015/01/19 v5.1.0b Thesis Template For MCM/ICM]
\typeout{Thesis Template For MCM/ICM}
\def\MCMversion{v5.1.0b}
\RequirePackage{kvoptions}
\RequirePackage{etoolbox}
\SetupKeyvalOptions{family=MCM, prefix=MCM@opt@, setkeys=\kvsetkeys}
\newcommand{\skv}[1]{\kvsetkeys{MCM}{#1}}
\DeclareBoolOption[true]{sheet}
\DeclareComplementaryOption{nosheet}{sheet}
\DeclareBoolOption[true]{abstract}
\DeclareComplementaryOption{noabstract}{abstract}
\DeclareStringOption[0000]{tcn}[0000]
\DeclareDefaultOption{\relax}
\ProcessKeyvalOptions*\relax
\LoadClass[a4paper, 11pt]{article}
\newcommand{\control}{\MCM@opt@tcn}
\newcommand{\team}{Team \#\ \MCM@opt@tcn}
\RequirePackage{fancyhdr, fancybox}
\RequirePackage{ifthen}
\RequirePackage{lastpage}
\RequirePackage{listings}
\RequirePackage[toc, page, title, titletoc, header]{appendix}
\RequirePackage{paralist}
\RequirePackage{amsthm, amsfonts}
\RequirePackage{amsmath, bm}
\RequirePackage{amssymb, mathrsfs}
\RequirePackage{latexsym}
\RequirePackage{longtable, multirow, hhline, tabularx, array}
\RequirePackage{flafter}
\RequirePackage{pifont, calc}
\RequirePackage{colortbl, booktabs}
\RequirePackage{geometry}
\RequirePackage[T1]{fontenc}
\RequirePackage[scaled]{berasans}
\RequirePackage{hyperref}
\RequirePackage{ifpdf, ifxetex}
\ifpdf
  \RequirePackage{graphicx}
  \RequirePackage{epstopdf}
\else
  \ifxetex
    \RequirePackage{graphicx}
  \else
    \RequirePackage[dvipdfmx]{graphicx}
    \RequirePackage{bmpsize}
  \fi
\fi
\RequirePackage{xcolor}
\ifpdf
  \hypersetup{hidelinks}
\else
  \ifxetex
    \hypersetup{hidelinks}
  \else
    \hypersetup{dvipdfm, hidelinks}
  \fi
\fi
\geometry{a4paper, margin = 1.2in}
\pagestyle{fancy}
\fancyhf{}
\lhead{\small \team}
\rhead{\small Page \thepage\ of \pageref{LastPage}}
\setlength\parskip{.5\baselineskip}
\renewcommand\tableofcontents{%
    \centerline{\normalfont\Large\bfseries\contentsname
        \@mkboth{%
           \MakeUppercase\contentsname}{\MakeUppercase\contentsname}}%
    \vskip 5ex%
    \@starttoc{toc}%
    }
\setcounter{totalnumber}{4}
\setcounter{topnumber}{2}
\setcounter{bottomnumber}{2}
\renewcommand{\textfraction}{0.15}
\renewcommand{\topfraction}{0.85}
\renewcommand{\bottomfraction}{0.65}
\renewcommand{\floatpagefraction}{0.60}
\renewcommand{\figurename}{Figure}
\renewcommand{\tablename}{Table}
\graphicspath{{./}{./img/}{./fig/}{./image/}{./figure/}{./picture/}
            {./imgs/}{./figs/}{./images/}{./figures/}{./pictures/}}
\def\@maketitle{%
  \ifMCM@opt@sheet%
  \makesheet%
  \fi
  \newpage
  \null
  \vskip 2em%
  \begin{center}%
  \let \footnote \thanks
    {\LARGE \@title \par}%
    \vskip 1.5em%
    {\large
      \lineskip .5em%
      \begin{tabular}[t]{c}%
        \@author
      \end{tabular}\par}%
    \vskip 1em%
    {\large \@date}%
  \end{center}%
  \par
  \vskip 1.5em%
  \ifMCM@opt@abstract%
  \make@abstract%
  \fi%
}
\def\keywordsname{{\bfseries Keywords:}}
\def\@abstract{}%
\newbox\@abstract%
\setbox\@abstract\hbox{}%
\long\def\abstract{\bgroup\global\setbox\@abstract%
  \vbox\bgroup\hsize\textwidth\leftskip1cm\rightskip1cm}%
\def\endabstract{\egroup\egroup}
\newbox\@keywords
\setbox\@keywords\hbox{}
\def\keywords{\bgroup\global\setbox\@keywords\vbox\bgroup\noindent\leftskip0cm}
\def\endkeywords{\egroup\egroup}%
\def\make@abstract{%
\par%
\centerline{\bfseries\abstractname}\vskip5pt\par%
\noindent\usebox\@abstract\par%
\noindent\hskip1cm\keywordsname\ \usebox\@keywords%
\vskip10pt%
}
\newcommand{\@problem}[1]{}
\newcommand{\problem}[1]{\gdef\@problem{#1}}
\def\makesheet{%
  \null%
  \vskip 3em%
  \begingroup\fontfamily{fvs}\fontseries{m}\selectfont%
  \thispagestyle{empty}%
  \noindent\begin{tabularx}{0.3\textwidth}{lX}%
  \multicolumn{2}{l}{For office use only}\\
    T1&\rule{3cm}{0.5pt}\\
    T2&\rule{3cm}{0.5pt}\\
    T3&\rule{3cm}{0.5pt}\\
    T4&\rule{3cm}{0.5pt}\\
    \end{tabularx}\hspace{\fill}
    \begin{minipage}{0.33\textwidth}
    \centering
    Team Control Number\\[10pt]
    {\fontsize{38pt}{25pt}\selectfont  \textbf{\MCM@opt@tcn} }%
      \normalsize\\[10pt]
    Problem Chosen\\[10pt]
    {\fontsize{20pt}{\baselineskip}\selectfont \textbf{\@problem}}\normalsize\\
    \end{minipage}\hspace{\fill}
    \begin{tabularx}{0.28\textwidth}{lX}%
    \multicolumn{2}{l}{For office use only}\\
    F1&\rule{3cm}{0.5pt}\\
    F2&\rule{3cm}{0.5pt}\\
    F3&\rule{3cm}{0.5pt}\\
    F4&\rule{3cm}{0.5pt}\\
    \end{tabularx}\par
\noindent\rule{\textwidth}{0.5pt}\par
\begin{center}
  \textbf{\the\year\ Mathematical Contest in Modeling (MCM) Summary Sheet}\\
(Attach a copy of this page to each copy of your solution paper.)
\end{center}
\par%
\vskip 1.5em%
\centerline{\large\bfseries\abstractname}
\noindent\usebox\@abstract%
\endgroup}
\newtheorem{Theorem}{Theorem}[section]
\newtheorem{Lemma}[Theorem]{Lemma}
\newtheorem{Corollary}[Theorem]{Corollary}
\newtheorem{Proposition}[Theorem]{Proposition}
\newtheorem{Definition}[Theorem]{Definition}
\newtheorem{Example}[Theorem]{Example}
\providecommand{\dif}{\mathop{}\!\mathrm{d}}
\providecommand{\me}{\mathrm{e}}
\providecommand{\mi}{\mathrm{i}}
\definecolor{grey}{rgb}{0.8,0.8,0.8}
\definecolor{darkgreen}{rgb}{0,0.3,0}
\definecolor{darkblue}{rgb}{0,0,0.3}
\def\lstbasicfont{\fontfamily{pcr}\selectfont\footnotesize}
\lstset{%
   % numbers=left,
   % numberstyle=\small,%
    showstringspaces=false,
    showspaces=false,%
    tabsize=4,%
    frame=lines,%
    basicstyle={\footnotesize\lstbasicfont},%
    keywordstyle=\color{darkblue}\bfseries,%
    identifierstyle=,%
    commentstyle=\color{darkgreen},%\itshape,%
    stringstyle=\color{black}%
}
\lstloadlanguages{C,C++,Java,Matlab,Mathematica}
\endinput
%% 
%% This work consists of these files mcmthesis.dtx,
%%                                   figures/ and
%%                                   code/,
%% and the derived files             mcmthesis.cls,
%%                                   mcmthesis-demo.tex,
%%                                   README,
%%                                   LICENSE,
%%                                   mcmthesis.pdf and
%%                                   mcmthesis-demo.pdf.
%%
%% End of file `mcmthesis.cls'.
