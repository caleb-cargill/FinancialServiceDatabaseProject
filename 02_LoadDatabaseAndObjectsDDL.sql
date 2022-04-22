/* DELIVERABLE #2: DDL SCRIPTS TO CREATE DATABASE & OBJECTS */

USE [master]
GO
/****** Object:  Database [FinancialService]    Script Date: 4/22/2022 9:45:56 AM ******/
CREATE DATABASE [FinancialService]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'FinancialService', FILENAME = N'C:\Users\caleb\FinancialService.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'FinancialService_log', FILENAME = N'C:\Users\caleb\FinancialService_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [FinancialService] SET COMPATIBILITY_LEVEL = 130
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [FinancialService].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [FinancialService] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [FinancialService] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [FinancialService] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [FinancialService] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [FinancialService] SET ARITHABORT OFF 
GO
ALTER DATABASE [FinancialService] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [FinancialService] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [FinancialService] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [FinancialService] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [FinancialService] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [FinancialService] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [FinancialService] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [FinancialService] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [FinancialService] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [FinancialService] SET  DISABLE_BROKER 
GO
ALTER DATABASE [FinancialService] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [FinancialService] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [FinancialService] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [FinancialService] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [FinancialService] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [FinancialService] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [FinancialService] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [FinancialService] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [FinancialService] SET  MULTI_USER 
GO
ALTER DATABASE [FinancialService] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [FinancialService] SET DB_CHAINING OFF 
GO
ALTER DATABASE [FinancialService] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [FinancialService] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [FinancialService] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [FinancialService] SET QUERY_STORE = OFF
GO
USE [FinancialService]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
USE [FinancialService]
GO
/****** Object:  Table [dbo].[Account]    Script Date: 4/22/2022 9:45:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Account](
	[Acnt_Num] [int] NOT NULL,
	[Acnt_Type_Id] [int] NOT NULL,
	[Acnt_Amount] [decimal](18, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Acnt_Num] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Account_Type]    Script Date: 4/22/2022 9:45:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Account_Type](
	[Acnt_Type_Id] [int] IDENTITY(1,1) NOT NULL,
	[Acnt_Type] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Acnt_Type_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Role]    Script Date: 4/22/2022 9:45:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Role](
	[User_Id] [int] NOT NULL,
	[Acnt_Num] [int] NOT NULL,
	[Role_Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_UserAcnt] PRIMARY KEY CLUSTERED 
(
	[User_Id] ASC,
	[Acnt_Num] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Role_Type]    Script Date: 4/22/2022 9:45:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Role_Type](
	[Role_Name] [varchar](50) NOT NULL,
	[Role_Rank] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Role_Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Transaction]    Script Date: 4/22/2022 9:45:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Transaction](
	[TR_ID] [int] IDENTITY(1,1) NOT NULL,
	[TR_Type_Name] [varchar](50) NOT NULL,
	[TR_Amount] [decimal](18, 2) NOT NULL,
	[Acnt_Num] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TR_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Transaction_Type]    Script Date: 4/22/2022 9:45:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Transaction_Type](
	[TR_Type_Name] [varchar](50) NOT NULL,
	[TR_Type] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TR_Type_Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User]    Script Date: 4/22/2022 9:45:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[User_Id] [int] IDENTITY(1,1) NOT NULL,
	[User_FName] [varchar](100) NOT NULL,
	[User_LName] [varchar](100) NOT NULL,
	[User_Email] [varchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[User_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[User_Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Account]  WITH CHECK ADD  CONSTRAINT [FK_Account_Type] FOREIGN KEY([Acnt_Type_Id])
REFERENCES [dbo].[Account_Type] ([Acnt_Type_Id])
GO
ALTER TABLE [dbo].[Account] CHECK CONSTRAINT [FK_Account_Type]
GO
ALTER TABLE [dbo].[Role]  WITH CHECK ADD  CONSTRAINT [FK_Role_Account] FOREIGN KEY([Acnt_Num])
REFERENCES [dbo].[Account] ([Acnt_Num])
GO
ALTER TABLE [dbo].[Role] CHECK CONSTRAINT [FK_Role_Account]
GO
ALTER TABLE [dbo].[Role]  WITH CHECK ADD  CONSTRAINT [FK_Role_Type] FOREIGN KEY([Role_Name])
REFERENCES [dbo].[Role_Type] ([Role_Name])
GO
ALTER TABLE [dbo].[Role] CHECK CONSTRAINT [FK_Role_Type]
GO
ALTER TABLE [dbo].[Role]  WITH CHECK ADD  CONSTRAINT [FK_Role_User] FOREIGN KEY([User_Id])
REFERENCES [dbo].[User] ([User_Id])
GO
ALTER TABLE [dbo].[Role] CHECK CONSTRAINT [FK_Role_User]
GO
ALTER TABLE [dbo].[Transaction]  WITH CHECK ADD  CONSTRAINT [FK_Transaction_Account] FOREIGN KEY([Acnt_Num])
REFERENCES [dbo].[Account] ([Acnt_Num])
GO
ALTER TABLE [dbo].[Transaction] CHECK CONSTRAINT [FK_Transaction_Account]
GO
ALTER TABLE [dbo].[Transaction]  WITH CHECK ADD  CONSTRAINT [FK_Transaction_Type] FOREIGN KEY([TR_Type_Name])
REFERENCES [dbo].[Transaction_Type] ([TR_Type_Name])
GO
ALTER TABLE [dbo].[Transaction] CHECK CONSTRAINT [FK_Transaction_Type]
GO
USE [master]
GO
ALTER DATABASE [FinancialService] SET  READ_WRITE 
GO
