CREATE TABLE tblPages (
  [PageId] COUNTER CONSTRAINT PrimaryKey PRIMARY KEY,
  [PageName] TEXT (50),
  [PageFileName] TEXT (50),
  [PageHoverText] TEXT (255),
  [PageDescription] TEXT (255),
  [PageKeywords] TEXT (255),
  [CreatedDate] DATE
)
-- this is comment text
CREATE TABLE tblPageContent (
  [ContentId] COUNTER CONSTRAINT PrimaryKey PRIMARY KEY,
  [PageId] INT,
  [PageContent] TEXT (50),
  [ModifiedDate] DATE
)
