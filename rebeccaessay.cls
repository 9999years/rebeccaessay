\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{rebeccaessay}[2019/01/11 1.0.0 Personal document class for MLA-cited essays]
\errorcontextlines 10

\RequirePackage{xparse}

\PassOptionsToClass{12pt}{article}
\PassOptionsToPackage{
	fonts,
	footnote,
	quote,
	bib
}{rebeccastyle}

% passes an option to rebeccastyle
\newcommand{\rebeccaessay@passoption}[1]
	{\DeclareOption{#1}{%
		\PassOptionsToPackage{\CurrentOption}{rebeccastyle}%
	}}

% pass a comma-list of options
\NewDocumentCommand{\rebeccaessay@passoptions}{>{\SplitList{,}} m}
	{\ProcessList{#1}{\rebeccaessay@passoption}}

% options for rebeccastyle
\rebeccaessay@passoptions{
	tabu, notabu,
	figure, nofigure,
	list, nolist,
	fonts, nofonts,
	times, garamond,
	footnote, nofootnote,
	quote, noquote,
	1, 1.5, 2,
	bib, nobib,
}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions*

\LoadClass{article}
\RequirePackage{rebeccastyle}

% util
\RequirePackage{changepage} % for adjustwidth env
\RequirePackage{etoolbox} % for suppressindent

% formatting

\raggedbottom
\setlength{\parindent}{0.5in}
\setlength{\parskip}{0em}

\newcommand{\rebeccaessay@suppressindent}{\par\@afterindentfalse\@afterheading}
\newcommand*\NoIndentAfterEnv[1]{\AfterEndEnvironment{#1}{\suppressindent}}
\NoIndentAfterEnv{displayquote}
\NoIndentAfterEnv{enumerate}

\def\email@style{}
\newcommand{\email}[1]{\href{mailto:#1}{\email@style#1}}

\define@cmdkeys{heading}{instructor, course, date}
\newcommand{\heading}[1]{%
	\setkeys{heading}{#1}%
	\thispagestyle{empty}%
	%\vspace*{-1in}%
	{
		\setlength{\parindent}{0em}%
		\@author

	\ifx\cmdKV@heading@instructor\undefined\else\cmdKV@heading@instructor\par\fi
	\ifx\cmdKV@heading@course\undefined\else\cmdKV@heading@course\par\fi
	\ifx\cmdKV@heading@date\undefined\@date\else\cmdKV@heading@date\par\fi
	\vspace{1em}}}

\newcommand{\intro}[1]{\pagebreak\heading{#1}\maketitle\suppressindent}

\newcommand{\sectionskip}{\vspace{1em}}

\define@cmdkeys{address}{street, city, phone, email}
\newcommand{\address}[1]{%
	\begin{flushright}
	\setkeys{address, coverletter}{#1}
	\thispagestyle{empty}
	\vspace*{-1in}
	\@author

	\ifx\cmdKV@address@street\undefined\else\cmdKV@address@street\\\fi
	\ifx\cmdKV@address@city\undefined\else\cmdKV@address@city\par\fi
	\ifx\cmdKV@address@phone\undefined\else\cmdKV@address@phone\par\fi

	\ifx\cmdKV@address@email\undefined\else\email{\cmdKV@address@email}\par\fi
	\today
\end{flushright}
\vspace{1em}}

\define@cmdkey{coverletter}{to}{}
\define@cmdkey{coverletter}{dear}{}
\define@cmdkey{coverletter}{signature}{}
\presetkeys{coverletter}{dear={}, signature={Sincerely,}}{}
\newenvironment{coverletter}[1]
	{\address{#1}

	\cmdKV@coverletter@dear \cmdKV@coverletter@to,

	\suppressindent}
	{\sectionskip
	\noindent\hspace*{0.5in}\cmdKV@coverletter@signature \\
	\hspace*{0.5in}\hspace*{2em}--- \@author}
