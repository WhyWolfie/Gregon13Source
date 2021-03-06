USE GunzDB
GO

ALTER PROCEDURE dbo.spWebGetSurvivalRankingByCharacter
	@SID		TINYINT
	, @CName	VARCHAR(24)
AS 
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @CID INT;
	DECLARE @AID INT;
	DECLARE @Level INT;
	
	SELECT @AID = AID, @CID = CID, @Level = Level FROM dbo.Character WHERE Name = @CName;
		
	SELECT	r.Ranking AS Ranking 
			, @CName AS CharacName
			, (SELECT UserID FROM Account WHERE AID = @AID) AS UserID
			, @Level AS Level
			, s.RP AS RankingPoint
	FROM	dbo.SurvivalCharacterInfo s(NOLOCK)
			, dbo.SurvivalRanking r WITH (NOLOCK)
	WHERE	s.SID = @SID
	AND		s.CID = @CID
	AND		r.SID = s.SID
	AND		r.RP = s.RankRP
	AND		s.DeleteFlag != 1
	ORDER BY s.SID
END
GO