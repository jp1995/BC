table 50100 Reward
{
    DataClassification = ToBeClassified;

    fields
    {
        // The "Reward ID" field represents the unique identifier 
        // of the reward and can contain up to 30 Code characters. 
        field(1; "Reward ID"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        // The "Description" field can contain a string 
        // with up to 250 characters.
        field(2; Description; Text[250])
        {
            // This property specified that 
            // this field cannot be left empty.
            NotBlank = true;
        }
        // The "Discount Percentage" field is a Decimal numeric value
        // that represents the discount that will 
        // be applied for this reward.
        field(3; "Discount Percentage"; Decimal)
        {
            // The "MinValue" property sets the minimum value for the "Discount Percentage" 
            // field.
            MinValue = 0;
            // The "MaxValue" property sets the maximum value for the "Discount Percentage"
            // field.
            MaxValue = 100;
            // The "DecimalPlaces" property is set to 2 to display discount values with  
            // exactly 2 decimals.
            DecimalPlaces = 2;
        }
        // Field for designer tutorial
        field(4; "Minimum Purchase"; Decimal)
        {
            MinValue = 0;
            DecimalPlaces = 2;
        }
    }
    keys
    {
        // The field "Reward ID" is used as the primary key of this table.
        key(PK; "Reward ID")
        {
            // Create a clustered index from this key.
            Clustered = true;
        }
    }
}
page 50101 "Reward Card"
{
    // The page will be of type "Card" and will render as a card.
    PageType = Card;
    // The page will be part of the "Tasks" group of search results.
    UsageCategory = Tasks;
    // The source table shows data from the "Reward" table.
    SourceTable = Reward;

    ContextSensitiveHelpPage = 'rewards';

    // The layout describes the visual parts on the page.
    layout
    {
        area(content)
        {
            group(Reward)
            {
                field("Reward Id"; Rec."Reward ID")
                {
                    // ApplicationArea sets the application area that 
                    // applies to the page field and action controls. 
                    // Setting the property to All means that the control 
                    // will always appear in the user interface.
                    ApplicationArea = All;
                    ToolTip = 'Specifies the level of reward that the customer has at this point.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Discount Percentage"; Rec."Discount Percentage")
                {
                    ApplicationArea = All;
                }
                field("Minimum Purchase40422"; Rec."Minimum Purchase")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
page 50102 "Reward List"
{
    // Specify that this page will be a list page.
    PageType = List;
    // The page will be part of the "Lists" group of search results.
    UsageCategory = Lists;
    // The data of this page is taken from the "Reward" table.
    SourceTable = Reward;
    // The "CardPageId" is set to the Reward Card previously created.
    // This will allow users to open records from the list in the "Reward Card" page.
    CardPageId = "Reward Card";

    ContextSensitiveHelpPage = 'help-links';

    layout
    {
        area(content)
        {
            repeater(Rewards)
            {
                field("Reward ID"; Rec."Reward ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the level of reward that the customer has at this point.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Discount Percentage"; Rec."Discount Percentage")
                {
                    ApplicationArea = All;
                }
                field("Minimum Purchase34971"; Rec."Minimum Purchase")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
