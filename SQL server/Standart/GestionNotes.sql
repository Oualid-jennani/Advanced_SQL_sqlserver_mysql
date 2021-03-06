USE [GestionNotes]
GO
/****** Object:  Table [dbo].[etudiant]    Script Date: 25/10/2018 10:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[etudiant](
	[numE] [smallint] IDENTITY(1,1) NOT NULL,
	[nom] [varchar](30) NULL,
	[prenom] [varchar](30) NULL,
	[moyenne] [float] NULL,
	[numG] [smallint] NULL,
PRIMARY KEY CLUSTERED 
(
	[numE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[evaluer]    Script Date: 25/10/2018 10:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[evaluer](
	[numE] [smallint] NOT NULL,
	[numM] [smallint] NOT NULL,
	[dateE] [date] NULL,
	[note] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[numE] ASC,
	[numM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[filiere]    Script Date: 25/10/2018 10:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[filiere](
	[numF] [smallint] IDENTITY(1,1) NOT NULL,
	[libelle] [varchar](50) NULL,
	[code] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[numF] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[groupe]    Script Date: 25/10/2018 10:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[groupe](
	[numG] [smallint] IDENTITY(1,1) NOT NULL,
	[code] [tinyint] NULL,
	[numF] [smallint] NULL,
PRIMARY KEY CLUSTERED 
(
	[numG] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[matiere]    Script Date: 25/10/2018 10:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[matiere](
	[numM] [smallint] IDENTITY(1,1) NOT NULL,
	[nom] [varchar](30) NULL,
	[coeffMat] [tinyint] NULL,
PRIMARY KEY CLUSTERED 
(
	[numM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[etudiant]  WITH CHECK ADD  CONSTRAINT [fk_g] FOREIGN KEY([numG])
REFERENCES [dbo].[groupe] ([numG])
GO
ALTER TABLE [dbo].[etudiant] CHECK CONSTRAINT [fk_g]
GO
ALTER TABLE [dbo].[evaluer]  WITH CHECK ADD FOREIGN KEY([numE])
REFERENCES [dbo].[etudiant] ([numE])
GO
ALTER TABLE [dbo].[evaluer]  WITH CHECK ADD FOREIGN KEY([numM])
REFERENCES [dbo].[matiere] ([numM])
GO
ALTER TABLE [dbo].[groupe]  WITH CHECK ADD FOREIGN KEY([numF])
REFERENCES [dbo].[filiere] ([numF])
GO
