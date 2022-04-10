USE [Covid19_SHA]
GO
/****** Object:  Table [dbo].[tArea]    Script Date: 2022/4/10 14:27:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tArea](
	[AreaID] [int] IDENTITY(1,1) NOT NULL,
	[District] [nvarchar](100) NULL,
	[Street] [nvarchar](100) NULL,
	[CreatedDatetime] [datetime] NULL CONSTRAINT [DF_tArea_CreatedDatetime]  DEFAULT (getdate()),
 CONSTRAINT [PK_tArea] PRIMARY KEY CLUSTERED 
(
	[AreaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tNews]    Script Date: 2022/4/10 14:27:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tNews](
	[NewsID] [int] IDENTITY(1,1) NOT NULL,
	[Href] [nvarchar](100) NULL,
	[Title] [nvarchar](100) NULL,
	[NewsContentDate] [date] NULL,
	[CreatedDatetime] [datetime] NULL CONSTRAINT [DF_tNews_Createddatetime]  DEFAULT (getdate()),
	[Recorded] [bit] NULL CONSTRAINT [DF_tNews_Recorded]  DEFAULT ((0)),
 CONSTRAINT [PK_tNews] PRIMARY KEY CLUSTERED 
(
	[NewsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tPositiveArea]    Script Date: 2022/4/10 14:27:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tPositiveArea](
	[PositiveAreaID] [int] IDENTITY(1,1) NOT NULL,
	[CheckDate] [date] NULL,
	[AreaID] [int] NULL,
	[CreatedDatetime] [datetime] NULL CONSTRAINT [DF_tPositiveArea_CreatedDatetime]  DEFAULT (getdate()),
 CONSTRAINT [PK_tPositiveArea] PRIMARY KEY CLUSTERED 
(
	[PositiveAreaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tPositiveDistrict]    Script Date: 2022/4/10 14:27:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tPositiveDistrict](
	[PositiveDistrict] [int] IDENTITY(1,1) NOT NULL,
	[NewsDay] [date] NULL,
	[District] [nvarchar](100) NULL,
	[ConfirmedQty] [int] NULL,
	[AsymptomaticQty] [int] NULL,
	[CreatedDatetime] [datetime] NULL,
 CONSTRAINT [PK_tPositiveDistrict] PRIMARY KEY CLUSTERED 
(
	[PositiveDistrict] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  View [dbo].[vw_PositiveArea]    Script Date: 2022/4/10 14:27:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_PositiveArea]
AS
select a.District,a.Street,pa.CheckDate from tArea a
	join tPositiveArea pa on a.AreaID=pa.AreaID

GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_tArea_District_Street]    Script Date: 2022/4/10 14:27:31 ******/
CREATE NONCLUSTERED INDEX [IX_tArea_District_Street] ON [dbo].[tArea]
(
	[District] ASC,
	[Street] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_tArea_Street]    Script Date: 2022/4/10 14:27:31 ******/
CREATE NONCLUSTERED INDEX [IX_tArea_Street] ON [dbo].[tArea]
(
	[Street] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_tNews_Href]    Script Date: 2022/4/10 14:27:31 ******/
CREATE NONCLUSTERED INDEX [IX_tNews_Href] ON [dbo].[tNews]
(
	[Href] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_tPositiveArea]    Script Date: 2022/4/10 14:27:31 ******/
CREATE NONCLUSTERED INDEX [IX_tPositiveArea] ON [dbo].[tPositiveArea]
(
	[CheckDate] ASC,
	[AreaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_tPositiveArea_AreaID]    Script Date: 2022/4/10 14:27:31 ******/
CREATE NONCLUSTERED INDEX [IX_tPositiveArea_AreaID] ON [dbo].[tPositiveArea]
(
	[AreaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tPositiveDistrict] ADD  CONSTRAINT [DF_tPositiveDistrict_CreatedDatetime]  DEFAULT (getdate()) FOR [CreatedDatetime]
GO
/****** Object:  StoredProcedure [dbo].[uspInsertNews]    Script Date: 2022/4/10 14:27:31 ******/
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
exec dbo.uspInsertNews @Href='http://wsjkw.sh.gov.cn/xwfb/20220328/12b074e3958e448ab6bfb52e739d1d1e.html',@Title='【最新】3月27日（0-24时）本市各区确诊病例、无症状感染者居住地信息'
-- =============================================
*/
CREATE PROCEDURE [dbo].[uspInsertNews]
	@Href nvarchar(100),
	@Title nvarchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    if exists (select 1 from tNews t where t.Href=@Href)
		return

	--to get @NewsContentDate
	declare @TempTitle nvarchar(100)=@Title
	select @TempTitle=replace(@TempTitle,'【最新】','')
	declare @Month int=left(@TempTitle,charindex('月',@TempTitle)-1)
	select @TempTitle=SUBSTRING(@TempTitle,charindex('月',@TempTitle)+1,100)
	declare @Day int=left(@TempTitle,charindex('日',@TempTitle)-1)
	declare @NewsContentDate datetime=dateadd(yy,datediff(yy,0,getdate()),0)
	select @NewsContentDate=dateadd(mm,@Month-1,dateadd(dd,@Day-1,@NewsContentDate))

	insert dbo.tNews(Href,Title,NewsContentDate)
		values(@Href,@Title,@NewsContentDate)
	
END


GO
/****** Object:  StoredProcedure [dbo].[uspInsertPositiveArea]    Script Date: 2022/4/10 14:27:31 ******/
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

exec dbo.uspInsertPositiveArea 'https://wsjkw.sh.gov.cn/xwfb/20220320/f9f1683cf055471fb1a67b8586e36660.html','浦东新区','利津路1313弄'

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
