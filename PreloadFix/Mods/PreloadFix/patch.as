@open Vino/Characters/PlayerCharacter.as

@import Mods.PreloadFix.Preloader

@patch auto function Tick
    void Tick(float DeltaTime)
	{
		// Global player shader location, used for various effects such as bushes moving out of the way.
		FVector PlayerLocation = GetActorLocation();
		FVector PlayerVelocity = GetActorVelocity();

		AccumulatedVelocity += PlayerVelocity;
		AccumulatedVelocity = FMath::Lerp(AccumulatedVelocity, FVector::ZeroVector, FMath::Clamp(DeltaTime * 4.0f, 0.0f, 1.0f));
		
		Material::SetVectorParameterValue(WorldShaderParameters,
			IsCody() ? n"CodyLocation" : n"MayLocation",
			FLinearColor(PlayerLocation.X, PlayerLocation.Y, PlayerLocation.Z, AccumulatedVelocity.Size()));

		auto Parameter = Niagara::GetNiagaraParameterCollection(WorldNiagaraParameters);
		Parameter.SetVectorParameter(
			IsCody() ? n"NPC.NiagaraWorldParameters.CodyLocation"
					 : n"NPC.NiagaraWorldParameters.MayLocation",
			PlayerLocation);
			
		// global character material fresnel effect used for making characters show up more clearly against backgrounds.
		if(bFresnelDisabledByCutscene != bIsParticipatingInCutscene)
		{	
			if(bIsParticipatingInCutscene)
			{
				DisableCharacterFresnel(CharacterMaterialParameters, 1.0f);
				bFresnelDisabledByCutscene = true;
			}
			else
			{
				if(!GetOtherPlayer().bIsParticipatingInCutscene) // only enable outline if no players are in a cutscene
				{
					EnableCharacterFresnel(CharacterMaterialParameters, 1.0f);
					bFresnelDisabledByCutscene = false;
				}
			}
		}

        if(Lobby::GetLobby().Network == EHazeLobbyNetwork::Local) {
            if(IsCody()) GetPreloader().Tick(DeltaTime);
        } else {
            if(HasControl()) GetPreloader().Tick(DeltaTime);
        }
	}
@end