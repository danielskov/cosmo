var PrefillMachine = {

    prefillCorrectly: function() {
        $("#sample_id").val("sample00");
        $("#name").val("John Doe");
        $("#email").val("john@doe.com");

        $("#latitude").val("56.08");
        $("#longitude").val("10.11");

        $("#be_zobs").val("0.0");
        $("#al_zobs").val("0.0");

        $("#be_conc").val("5.67e5");
        $("#al_conc").val("2.67e6");

        $("#be_uncer").val("2.6");
        $("#al_uncer").val("4.0");

        $("#be_prod_muons").val("5.33");
        $("#al_prod_muons").val("31.1");

        $("#be_prod_spall").val("0.106");
        $("#al_prod_spall").val("0.70");

        $("#rock_density").val("2650");

        $("#epsilon_gla_min").val("0.1");
        $("#epsilon_gla_max").val("1000");

        $("#epsilon_int_min").val("0.1");
        $("#epsilon_int_max").val("1000");

        $("#t_degla_min").val("10000");
        $("#t_degla_max").val("12000");

        $("input[name='rec_5kyr']").prop("checked", true);
    }
}

// run the prefiller
PrefillMachine.prefillCorrectly();
