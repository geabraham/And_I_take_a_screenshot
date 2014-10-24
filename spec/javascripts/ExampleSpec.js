describe('example spec', function(){
	it('should pass', function(){
		expect(1).toEqual(1);
	});
	it('should have jasmine-jquery', function(){
		loadFixtures('exampleFixture.html');
		expect($('.example')).toHaveText('Test')
	});
});
