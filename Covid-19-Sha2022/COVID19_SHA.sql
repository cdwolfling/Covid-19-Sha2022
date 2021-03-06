USE [master]
GO
/****** Object:  Database [Covid19_SHA]    Script Date: 4/15/2022 7:43:14 PM ******/
CREATE DATABASE [Covid19_SHA]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Covid19_SHA', FILENAME = N'D:\myDBs\Covid19_SHA\Covid19_SHA.mdf' , SIZE = 97536KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Covid19_SHA_Log', FILENAME = N'D:\myDBs\Covid19_SHA\Covid19_SHA_log.ldf' , SIZE = 63424KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Covid19_SHA] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Covid19_SHA].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Covid19_SHA] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Covid19_SHA] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Covid19_SHA] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Covid19_SHA] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Covid19_SHA] SET ARITHABORT OFF 
GO
ALTER DATABASE [Covid19_SHA] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Covid19_SHA] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Covid19_SHA] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Covid19_SHA] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Covid19_SHA] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Covid19_SHA] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Covid19_SHA] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Covid19_SHA] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Covid19_SHA] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Covid19_SHA] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Covid19_SHA] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Covid19_SHA] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Covid19_SHA] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Covid19_SHA] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Covid19_SHA] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Covid19_SHA] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Covid19_SHA] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Covid19_SHA] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Covid19_SHA] SET  MULTI_USER 
GO
ALTER DATABASE [Covid19_SHA] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Covid19_SHA] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Covid19_SHA] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Covid19_SHA] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [Covid19_SHA] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'Covid19_SHA', N'ON'
GO
ALTER DATABASE [Covid19_SHA] SET QUERY_STORE = OFF
GO
USE [Covid19_SHA]
GO
/****** Object:  Table [dbo].[tArea]    Script Date: 4/15/2022 7:43:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tArea](
	[AreaID] [int] IDENTITY(1,1) NOT NULL,
	[District] [nvarchar](100) NULL,
	[Street] [nvarchar](100) NULL,
	[CreatedDatetime] [datetime] NULL,
 CONSTRAINT [PK_tArea] PRIMARY KEY CLUSTERED 
(
	[AreaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tPositiveArea]    Script Date: 4/15/2022 7:43:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tPositiveArea](
	[PositiveAreaID] [int] IDENTITY(1,1) NOT NULL,
	[CheckDate] [date] NULL,
	[AreaID] [int] NULL,
	[CreatedDatetime] [datetime] NULL,
 CONSTRAINT [PK_tPositiveArea] PRIMARY KEY CLUSTERED 
(
	[PositiveAreaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_PositiveArea]    Script Date: 4/15/2022 7:43:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_PositiveArea]
AS
select a.District,a.Street,pa.CheckDate from tArea a
	join tPositiveArea pa on a.AreaID=pa.AreaID

GO
/****** Object:  Table [dbo].[t3Zones]    Script Date: 4/15/2022 7:43:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t3Zones](
	[3ZonesID] [int] IDENTITY(1,1) NOT NULL,
	[Href] [nvarchar](100) NULL,
	[Title] [nvarchar](100) NULL,
	[CreatedDatetime] [datetime] NULL,
	[Recorded] [bit] NULL,
 CONSTRAINT [PK_t3Zones] PRIMARY KEY CLUSTERED 
(
	[3ZonesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tNews]    Script Date: 4/15/2022 7:43:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tNews](
	[NewsID] [int] IDENTITY(1,1) NOT NULL,
	[Href] [nvarchar](100) NULL,
	[Title] [nvarchar](100) NULL,
	[NewsContentDate] [date] NULL,
	[CreatedDatetime] [datetime] NULL,
	[Recorded] [bit] NULL,
 CONSTRAINT [PK_tNews] PRIMARY KEY CLUSTERED 
(
	[NewsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_tArea_District_Street]    Script Date: 4/15/2022 7:43:15 PM ******/
CREATE NONCLUSTERED INDEX [IX_tArea_District_Street] ON [dbo].[tArea]
(
	[District] ASC,
	[Street] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_tArea_Street]    Script Date: 4/15/2022 7:43:15 PM ******/
CREATE NONCLUSTERED INDEX [IX_tArea_Street] ON [dbo].[tArea]
(
	[Street] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_tNews_Href]    Script Date: 4/15/2022 7:43:15 PM ******/
CREATE NONCLUSTERED INDEX [IX_tNews_Href] ON [dbo].[tNews]
(
	[Href] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_tPositiveArea]    Script Date: 4/15/2022 7:43:15 PM ******/
CREATE NONCLUSTERED INDEX [IX_tPositiveArea] ON [dbo].[tPositiveArea]
(
	[CheckDate] ASC,
	[AreaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_tPositiveArea_AreaID]    Script Date: 4/15/2022 7:43:15 PM ******/
CREATE NONCLUSTERED INDEX [IX_tPositiveArea_AreaID] ON [dbo].[tPositiveArea]
(
	[AreaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t3Zones] ADD  CONSTRAINT [DF_t3Zones_Createddatetime]  DEFAULT (getdate()) FOR [CreatedDatetime]
GO
ALTER TABLE [dbo].[t3Zones] ADD  CONSTRAINT [DF_t3Zones_Recorded]  DEFAULT ((0)) FOR [Recorded]
GO
ALTER TABLE [dbo].[tArea] ADD  CONSTRAINT [DF_tArea_CreatedDatetime]  DEFAULT (getdate()) FOR [CreatedDatetime]
GO
ALTER TABLE [dbo].[tNews] ADD  CONSTRAINT [DF_tNews_Createddatetime]  DEFAULT (getdate()) FOR [CreatedDatetime]
GO
ALTER TABLE [dbo].[tNews] ADD  CONSTRAINT [DF_tNews_Recorded]  DEFAULT ((0)) FOR [Recorded]
GO
ALTER TABLE [dbo].[tPositiveArea] ADD  CONSTRAINT [DF_tPositiveArea_CreatedDatetime]  DEFAULT (getdate()) FOR [CreatedDatetime]
GO
/****** Object:  StoredProcedure [dbo].[uspInsert3Zones]    Script Date: 4/15/2022 7:43:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
-- =============================================
-- Author:		Jackie
-- Create date: 2022/4/12
-- Description:	Insert 3Zones
example:
exec dbo.uspInsert3Zones @Href=N'https://mp.weixin.qq.com/s?__biz=MjM5NzQwMzk3NA==&amp;mid=2650782219&amp;idx=1&amp;sn=3452126786dbcb4d61ac20f58673b974&amp;scene=21#wechat_redirect',@Title=N'崇明区第一批''三区''划分管控区域的公告'

change log:
-- =============================================
*/
CREATE PROCEDURE [dbo].[uspInsert3Zones]
	@Href NVARCHAR(100),
	@Title NVARCHAR(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM t3Zones t WHERE t.Href=@Href)
		RETURN

	INSERT dbo.t3Zones(Href,Title)
		VALUES(@Href,@Title)
	
END


GO
/****** Object:  StoredProcedure [dbo].[uspInsertNews]    Script Date: 4/15/2022 7:43:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
-- =============================================
-- Author:		Jackie
-- Create date: 2022/4/9
-- Description:	Insert News
example:
exec dbo.uspInsertNews @Href=N'http://wsjkw.sh.gov.cn/xwfb/20220328/12b074e3958e448ab6bfb52e739d1d1e.html',@Title=N'【最新】3月27日（0-24时）本市各区确诊病例、无症状感染者居住地信息'

change log:
2022/4/11 JC: update inputs & some constents from char to nchar
-- =============================================
*/
CREATE PROCEDURE [dbo].[uspInsertNews]
	@Href NVARCHAR(100),
	@Title NVARCHAR(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM tNews t WHERE t.Href=@Href)
		RETURN

	--to get @NewsContentDate
	DECLARE @TempTitle NVARCHAR(100)=@Title
	SELECT @TempTitle=REPLACE(@TempTitle,N'【最新】','')
	DECLARE @Month INT=LEFT(@TempTitle,CHARINDEX(N'月',@TempTitle)-1)
	SELECT @TempTitle=SUBSTRING(@TempTitle,CHARINDEX(N'月',@TempTitle)+1,100)
	DECLARE @Day INT=LEFT(@TempTitle,CHARINDEX(N'日',@TempTitle)-1)
	DECLARE @NewsContentDate DATETIME=DATEADD(yy,DATEDIFF(yy,0,GETDATE()),0)
	SELECT @NewsContentDate=DATEADD(mm,@Month-1,DATEADD(dd,@Day-1,@NewsContentDate))

	INSERT dbo.tNews(Href,Title,NewsContentDate)
		VALUES(@Href,@Title,@NewsContentDate)
	
END


GO
/****** Object:  StoredProcedure [dbo].[uspInsertPositiveArea]    Script Date: 4/15/2022 7:43:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
-- =============================================
-- Author:		Jackie
-- Create date: 2022/4/9
-- Description:	Insert PositiveArea
example:

exec dbo.uspInsertPositiveArea N'https://wsjkw.sh.gov.cn/xwfb/20220320/f9f1683cf055471fb1a67b8586e36660.html',N'浦东新区',N'利津路1313弄'

change log:
2022/4/11 JC: update inputs & some constents from char to nchar
-- =============================================
*/
CREATE PROCEDURE [dbo].[uspInsertPositiveArea]
	@Href nvarchar(100),
	@District nvarchar(100),
	@Street nvarchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	declare @AreaID INT
	select @AreaID=AreaID from tArea t where t.District=@District and t.Street=@Street
    if @AreaID is null
	begin
		insert tArea(District,Street) values(@District,@Street)
		select @AreaID=AreaID from tArea t where t.District=@District and t.Street=@Street
	end

	declare @CheckDate date
	select @CheckDate=NewsContentDate from tNews t where t.Href=@Href

	if not exists(select 1 from dbo.tPositiveArea t where t.CheckDate=@CheckDate and t.AreaID=@AreaID)
	begin
		insert dbo.tPositiveArea(CheckDate,AreaID)
			values(@CheckDate,@AreaID)
	end
	
END


GO
USE [master]
GO
ALTER DATABASE [Covid19_SHA] SET  READ_WRITE 
GO

GO
USE [Covid19_SHA]
GO
EXEC dbo.uspInsertNews N'https://wsjkw.sh.gov.cn/xwfb/20220321/2cda1b24b5304d118352bdfd32af0aa4.html',N'3月20日（0-24时）本市各区确诊病例、无症状感染者居住地信息'
EXEC dbo.uspInsertNews N'https://wsjkw.sh.gov.cn/xwfb/20220322/b5bf11c3ef924f2e9d292ad14b0f3403.html',N'3月21日（0-24时）本市各区确诊病例、无症状感染者居住地信息'
EXEC dbo.uspInsertNews N'https://wsjkw.sh.gov.cn/xwfb/20220323/dd54a58cdf524a51af5ba113adc6730f.html',N'3月22日（0-24时）本市各区确诊病例、无症状感染者居住地信息'
EXEC dbo.uspInsertNews N'https://wsjkw.sh.gov.cn/xwfb/20220324/a8643ae53c7644f597cd88b8f2f4d8c4.html',N'3月23日（0-24时）本市各区确诊病例、无症状感染者居住地信息'
EXEC dbo.uspInsertNews N'https://wsjkw.sh.gov.cn/xwfb/20220325/a76fbb6a18f542cda80fa9a9a4b08dd3.html',N'3月24日（0-24时）本市各区确诊病例、无症状感染者居住地信息'
EXEC dbo.uspInsertNews N'https://wsjkw.sh.gov.cn/xwfb/20220326/ff80e7e71f00478abf80a7d057e1683b.html',N'3月25日（0-24时）本市各区确诊病例、无症状感染者居住地信息'
EXEC dbo.uspInsertNews N'https://wsjkw.sh.gov.cn/xwfb/20220327/09cfe78deb4041098d0042010fabdfeb.html',N'3月26日（0-24时）本市各区确诊病例、无症状感染者居住地信息'
EXEC dbo.uspInsertNews N'https://wsjkw.sh.gov.cn/xwfb/20220328/12b074e3958e448ab6bfb52e739d1d1e.html',N'【最新】3月27日（0-24时）本市各区确诊病例、无症状感染者居住地信息'
EXEC dbo.uspInsertNews N'https://wsjkw.sh.gov.cn/xwfb/20220329/b7430a2b3e04483c9d7ac6e4f4d4cf68.html',N'3月28日（0-24时）本市各区确诊病例、无症状感染者居住地信息'
EXEC dbo.uspInsertNews N'https://wsjkw.sh.gov.cn/xwfb/20220330/8d4f5179f1ef43da91c2d63cd906bfeb.html',N'3月29日（0-24时）本市各区确诊病例、无症状感染者居住地信息'
EXEC dbo.uspInsertNews N'https://wsjkw.sh.gov.cn/xwfb/20220331/e86a298aecdf4e94b1796089e943054b.html',N'3月30日（0-24时）本市各区确诊病例、无症状感染者居住地信息'
EXEC dbo.uspInsertNews N'https://wsjkw.sh.gov.cn/xwfb/20220401/8c101d231d5644df8ed92d6bdbfab236.html',N'3月31日（0-24时）本市各区确诊病例、无症状感染者居住地信息'
EXEC dbo.uspInsertNews N'https://wsjkw.sh.gov.cn/xwfb/20220402/e4dfcc8e58b14b3e8dab46d60ff6d767.html',N'4月1日（0-24时）本市各区确诊病例、无症状感染者居住地信息'
EXEC dbo.uspInsertNews N'https://wsjkw.sh.gov.cn/xwfb/20220403/c389b92483534c089fccd3f172c68595.html',N'4月2日（0-24时）本市各区确诊病例、无症状感染者居住地信息'
EXEC dbo.uspInsertNews N'https://wsjkw.sh.gov.cn/xwfb/20220404/ff41c17c2bec4154b800f22040d3754a.html',N'4月3日（0-24时）本市各区确诊病例、无症状感染者居住地信息'
EXEC dbo.uspInsertNews N'https://wsjkw.sh.gov.cn/xwfb/20220405/4c6aec72ef47453ba2a5643fad214b2a.html',N'4月4日（0-24时）本市各区确诊病例、无症状感染者居住地信息'
EXEC dbo.uspInsertNews N'https://mp.weixin.qq.com/s/djwW3S9FUYBE2L5Hj94a3A',N'4月5日（0-24时）本市各区确诊病例、无症状感染者居住地信息'
EXEC dbo.uspInsertNews N'https://mp.weixin.qq.com/s/8bljTUplPh1q4MXb6wd_gg',N'4月6日（0-24时）本市各区确诊病例、无症状感染者居住地信息'
EXEC dbo.uspInsertNews N'https://mp.weixin.qq.com/s/HTM47mUp0GF-tWXkPeZJlg',N'4月7日（0-24时）本市各区确诊病例、无症状感染者居住地信息'
EXEC dbo.uspInsertNews N'https://mp.weixin.qq.com/s/79NsKhMHbg09Y0xaybTXjA',N'4月8日（0-24时）本市各区确诊病例、无症状感染者居住地信息'
EXEC dbo.uspInsertNews N'https://mp.weixin.qq.com/s/_Je5_5_HqBcs5chvH5SFfA',N'4月9日（0-24时）本市各区确诊病例、无症状感染者居住地信息'
EXEC dbo.uspInsertNews N'https://mp.weixin.qq.com/s/u0XfHF8dgfEp8vGjRtcwXA',N'4月10日（0-24时）本市各区确诊病例、无症状感染者居住地信息'
EXEC dbo.uspInsertNews N'https://mp.weixin.qq.com/s/vxFiV2HeSvByINUlTmFKZA',N'4月11日（0-24时）本市各区确诊病例、无症状感染者居住地信息'
EXEC dbo.uspInsertNews N'https://mp.weixin.qq.com/s/OZGM-pNkefZqWr0IFRJj1g',N'【最新】4月12日（0-24时）本市各区确诊病例、无症状感染者居住地信息'
EXEC dbo.uspInsertNews N'https://mp.weixin.qq.com/s/L9AffT-SoEBV4puBa_mRqg',N'4月13日（0-24时）本市各区确诊病例、无症状感染者居住地信息'
EXEC dbo.uspInsertNews N'https://mp.weixin.qq.com/s/5T76lht3s6g_KTiIx3XAYw',N'4月14日（0-24时）本市各区确诊病例、无症状感染者居住地信息'
EXEC dbo.uspInsertNews N'https://mp.weixin.qq.com/s/ZkhimhWpa92I2EWn3hmd8w',N'4月15日（0-24时）本市各区确诊病例、无症状感染者居住地信息'
EXEC dbo.uspInsertNews N'https://mp.weixin.qq.com/s/dRa-PExJr1qkRis88eGCnQ',N'4月16日（0-24时）本市各区确诊病例、无症状感染者居住地信息'
EXEC dbo.uspInsertNews N'https://mp.weixin.qq.com/s/LguiUZj-zxy4xy19WO0_UA',N'4月17日（0-24时）本市各区确诊病例、无症状感染者居住地信息'