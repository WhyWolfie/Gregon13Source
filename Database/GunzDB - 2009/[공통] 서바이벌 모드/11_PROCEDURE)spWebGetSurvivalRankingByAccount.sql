USE GunzDB
GO

ALTER PROCEDURE dbo.spWebGetSurvivalRankingByAccount
	@SID		TINYINT
	, @AName	VARCHAR(64)
AS 
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @AID INT;
	SELECT @AID = AID FROM dbo.Account WITH (NOLOCK) WHERE UserID = @AName;
		
	SELECT	r.Ranking AS Ranking		
			, t.Name AS CharacName
			, @AName AS UserID
			, t.Level AS Level
			, r.RP AS RankingPoint
	FROM	(	SELECT	c.Name, c.Level, s.RankRP
				FROM	dbo.Character c(NOLOCK) 
						, dbo.SurvivalCharacterInfo s(NOLOCK)
				WHERE	AID = @AID
				AND		s.CID = c.CID
				AND		s.SID = @SID
				AND		s.DeleteFlag != 1
			) t
			, dbo.SurvivalRanking r WITH (NOLOCK)
	WHERE	r.SID = @SID
	AND		r.RP = t.RankRP
	ORDER BY Ranking
END
GO