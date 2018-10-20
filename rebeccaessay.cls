\ProvidesClass{rebeccaessay}[2018-10-19 0.0.1 Personal document class for
	MLA-cited essays]
\errorcontextlines 10

\PassOptionsToClass{12pt}{article}
\LoadClass{article}

% pages
\PassOptionsToPackage{
	letterpaper,
	margin=1in,
	tmargin=1in,
	bmargin=1.25in,
}{geometry}

\PassOptionsToPackage{
	style=mla,
	ibidtracker=context,
	idemtracker=context,
	opcittracker=context,
	loccittracker=context,
	url=false,
	backend=biber,
}{biblatex}

\PassOptionsToPackage{american}{babel}

\PassOptionsToPackage{bottom, hang}{footmisc}

\PassOptionsToPackage{factor=1500}{microtype}

% utility
\RequirePackage{xparse}
\RequirePackage{etoolbox}
\RequirePackage{xkeyval}
\RequirePackage{geometry}
\RequirePackage{changepage} % for adjustwidth env

% formatting
\RequirePackage{hyperref}
\RequirePackage{fancyhdr}
\RequirePackage{enumitem}
\RequirePackage{titlesec}
\RequirePackage{fontspec}
\RequirePackage{microtype}

% bib
\RequirePackage{csquotes}
\RequirePackage{babel}
\RequirePackage{biblatex}
\RequirePackage{footmisc}
\RequirePackage{microtype}
\RequirePackage{graphicx}
\RequirePackage{setspace}

\RequirePackage{kvoptions}
\DeclareBoolOption{1}
\DeclareBoolOption{1.5}
\DeclareBoolOption{2}
\DeclareStringOption[\relax]{surname}
\ProcessKeyvalOptions*

\csname ifrebeccaessay@1\endcsname
	\singlespacing
\fi
\csname ifrebeccaessay@1.5\endcsname
	\onehalfspacing
\fi
\csname ifrebeccaessay@2\endcsname
	\doublespacing
\fi

\setmainfont[
	Numbers=OldStyle,
]{Garamond Premier Pro}

\errorcontextlines 10
\widowpenalties 1 10000
\raggedbottom
\setlength{\parindent}{0.5in}
\setlength{\parskip}{0em}

\let\Sc\textsc
\let\Rm\textrm
\let\Up\textup
\let\Bf\textbf
\let\It\textit
\let\Tt\texttt
\let\ac\textsc

% bibliography
\renewcommand{\mkbegdispquote}[2]{\itshape}
\let\cite\parencite
\setlength{\bibhang}{0.5in}
\DeclareAutoCiteCommand{footnote}[f]{\footcite}{\footcites}

% natbib-like fullcite command
\DeclareCiteCommand{\fullcite}
	{\renewcommand{\finalnamedelim}
		{\ifnum\value{liststop}>2 \finalandcomma\fi\addspace\&\space}%
		\list{}
		{\setlength{\leftmargin}{\bibhang}%
			\setlength{\itemindent}{-\leftmargin}%
				\setlength{\itemsep}{\bibitemsep}%
				\setlength{\parsep}{\bibparsep}}\item}
	{\usedriver{}{\thefield{entrytype}}\finentry}
	{\item}
	{\endlist\global\undef\bbx@lasthash}

% rlapping \thesection gives us consistently aligned headings
\titleformat{\section}{\Large\scshape}{\rlap{\thesection}\hspace{0.5in}}{0em}{}[]
\titleformat{\subsection}{\large}{\rlap{\thesubsection}  \hspace{0.5in}}{0em}{}[]
\titleformat{\subsubsection}{}{\rlap{\thesubsubsection}  \hspace{0.5in}}{0em}{}[]
\titlespacing*{\section}{0em}{1em}{0.5em}[0em]
\titlespacing*{\subsection}{0em}{1em}{0.5em}[0em]
\titlespacing*{\subsubsection}{0em}{1em}{0.5em}[0em]

\pagestyle{fancy}
\fancyhf{}
\lhead{}
\rhead{\if\rebeccaessay@surname\relax
	\@author
\else
	\rebeccaessay@surname
\fi
\hspace{1em}\thepage}
\setlength{\headheight}{0.5in}
\fancypagestyle{plain}{\fancyhead[L]{}}
\renewcommand{\headrulewidth}{0pt}
\AtBeginDocument{\thispagestyle{empty}}
\newcommand{\suppressindent}{\par\@afterindentfalse\@afterheading}
\newcommand*\NoIndentAfterEnv[1]{\AfterEndEnvironment{#1}{\supressindent}}
\NoIndentAfterEnv{displayquote}
\NoIndentAfterEnv{enumerate}

\renewcommand{\maketitle}{
	\begin{center}
		\let\footnote\thanks
		{
			\LARGE
			\@title
			\par
		}
		\vskip 1em
		{
			\large
			\lineskip 0.5em
			\begin{tabular}[t]{c}
				\@author
			\end{tabular}
			\par
		}
		\vskip 0.5em
		{
			\large
			\@date
		}
	\end{center}
	\par
	\vskip 1.5em
	}

\renewcommand{\labelitemi}{---}

\newenvironment{bquote}
	{\vspace{1em}%
	\begin{center}%
	\begin{minipage}{0.85\linewidth}%
	\setlength{\parindent}{0.5in}}
	{\end{minipage}
	\end{center}
	\vspace{1em}}

\setlength{\footnotesep}{\baselineskip}

\newcommand{\email}[1]{\href{mailto:#1}{\texttt{#1}}}

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
	\ifx\cmdKV@heading@date\undefined\else\cmdKV@heading@date\par\fi
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
	{\setkeys{address, coverletter}{#1}%
	\address{#1}
	
	\cmdKV@coverletter@dear \cmdKV@coverletter@to,
	
	\suppressindent}
	{\sectionskip
	\noindent\hspace*{0.5in}\cmdKV@coverletter@signature \\
	\hspace*{0.5in}\hspace*{2em}--- \@author}

