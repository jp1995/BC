pageextension 50103 CatPicForItem extends "Item Card"
{
    actions
    {
        addlast(processing)
        {
            action("Get cat picture")
            {
                ApplicationArea = All;
                Image = Import;

                trigger OnAction()
                var
                    ApiUrl: Text;
                    JsonArr: JsonArray;
                    CatUrl: Text;
                begin
                    ApiUrl := 'https://api.thecatapi.com/v1/images/search';
                    JsonArr := GetJsonFromCatApi(ApiUrl);
                    CatUrl := GetUrlFromJson(JsonArr);
                    GetPictureFromUrl(CatUrl, Rec);
                end;
            }
        }
    }

    procedure GetJsonFromCatApi(ApiUrl: Text): JsonArray
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        JsonText: Text;
        JsonArr: JsonArray;
    begin
        Client.Get(ApiUrl, Response);
        if Response.HttpStatusCode = 200 then begin
            if Response.Content.ReadAs(JsonText) then begin
                JsonArr.ReadFrom(JsonText);
                exit(JsonArr);
            end;
        end
        else begin
            Error('API responded with error code %1', Response.HttpStatusCode);
        end;
    end;


    procedure GetUrlFromJson(JsonArr: JsonArray): Text
    var
        MainToken: JsonToken;
        JsonObj: JsonObject;
        UrlToken: JsonToken;
        UrlValue: JsonValue;
        CleanUrl: Text;
    begin
        if JsonArr.Count > 0 then begin
            JsonArr.Get(0, MainToken);
            JsonObj := MainToken.AsObject();

            if JsonObj.Contains('url') then begin
                JsonObj.Get('url', UrlToken);
                UrlValue := UrlToken.AsValue();
                CleanUrl := UrlValue.AsText();
                exit(CleanUrl);
            end
            else begin
                Error('The retrieved JSON array is missing the URL field.');
            end;
        end
        else begin
            Error('The retrieved JSON array is empty.');
        end;
    end;

    procedure GetPictureFromUrl(Url: Text; Item: Record Item) // 
    var
        Client: HttpClient;
        Content: HttpContent;
        Response: HttpResponseMessage;
        InStr: InStream;
    begin
        Client.Get(Url, Response);
        if Response.HttpStatusCode = 200 then begin
            Response.Content.ReadAs(InStr);
            Clear(Item.Picture);
            Item.Picture.ImportStream(InStr, 'Random cat picture');
            Item.Modify(true);
        end
        else begin
            Error('Failed to fetch picture.');
        end;
    end;

    // Passing instream object between methods, doesn't work, instream object is empty?
    // procedure GetPictureFromUrl(Url: Text): InStream
    // begin
    // end;

    // procedure ModifyCurrentPicture(CatPic: InStream; Item: Record Item)
    // begin
    // end;
}